/**
 * JBoss, Home of Professional Open Source
 * Copyright 2016, Red Hat, Inc. and/or its affiliates, and individual
 * contributors by the @authors tag. See the copyright.txt in the
 * distribution for a full listing of individual contributors.
 * <p/>
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.redhat.coolstore.api_gateway;

import java.util.Collections;
import java.util.List;

import javax.ws.rs.core.Response;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.redhat.coolstore.api_gateway.model.Rating;
import org.apache.camel.Exchange;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.component.http4.HttpMethods;
import org.apache.camel.component.jackson.JacksonDataFormat;
import org.apache.camel.component.jackson.ListJacksonDataFormat;
import org.apache.camel.model.dataformat.JsonLibrary;
import org.apache.camel.processor.aggregate.AggregationStrategy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;

import com.redhat.coolstore.api_gateway.model.Inventory;
import com.redhat.coolstore.api_gateway.model.Product;

@Component
public class ProductGateway extends RouteBuilder {
    private static final Logger LOG = LoggerFactory.getLogger(ProductGateway.class);

    @Autowired
    private Environment env;

    @Override
    public void configure() throws Exception {
        try {
            getContext().setTracing(Boolean.parseBoolean(env.getProperty("ENABLE_TRACER", "false")));
        } catch (Exception e) {
            LOG.error("Failed to parse the ENABLE_TRACER value: {}", env.getProperty("ENABLE_TRACER", "false"));
        }
    	
        
        JacksonDataFormat productFormatter = new ListJacksonDataFormat();
        productFormatter.setUnmarshalType(Product.class);
        productFormatter.disableFeature(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES);

       

        rest("/products/").description("Product Catalog Service").produces(MediaType.APPLICATION_JSON_VALUE)
        // Handle CORS Pre-flight requests
        .options("/")
            .route().id("productsOptions").end()
        .endRest()

        .get("/").description("Get product catalog").outType(Product.class)
            .route().id("productRoute").streamCaching()
                .setBody(simple("null")).removeHeaders("CamelHttp*")
                .log("header: ${headers}")
                .recipientList(simple("http4://{{env:CATALOG_ENDPOINT:catalog:8080}}/api/catalog"))
                .log("body: ${body}")
                .choice()
                    .when(body().isNull())
                        .to("direct:productFallback")
                    .end()
                    .unmarshal(productFormatter)
                .split(body()).parallelProcessing()
                .enrich("direct:inventory", new InventoryEnricher())
                .enrich("direct:rating", new RatingEnricher())
                .end()
        .endRest();
        
        

        from("direct:productFallback")
                .id("ProductFallbackRoute")
                .transform()
                .constant(Collections.singletonList(new Product("0", "Unavailable Product", "Unavailable Product", 0, null)));
                //.marshal().json(JsonLibrary.Jackson, List.class);


        from("direct:inventory")
            .id("inventoryRoute")
            .onException(Exception.class)
                .handled(true)
                .log("This is the error: ${exception.stacktrace}")
                .to("log:errorLogger?level=ERROR&showException=true&showStackTrace=true")
                .to("direct:inventoryFallback")
                .end()
            .setHeader("itemId", simple("${body.itemId}"))            
                .setBody(simple("null"))
                .removeHeaders("CamelHttp*")
                .recipientList(simple("http4://{{env:INVENTORY_ENDPOINT:inventory:8080}}/api/availability/${header.itemId}")).end()
            .choice().when(body().isNull())
                .to("direct:inventoryFallback")
            .end()
            .setHeader("CamelJacksonUnmarshalType", simple(Inventory.class.getName()))
            .unmarshal().json(JsonLibrary.Jackson, Inventory.class);

        from("direct:inventoryFallback")
                .id("inventoryFallbackRoute")
                .transform()
                .constant(new Inventory("0", 0, "Local Store", "http://developers.redhat.com"))
                .marshal().json(JsonLibrary.Jackson, Inventory.class);

        from("direct:rating")
                .id("ratingRoute")
                .setHeader("itemId", simple("${body.itemId}"))
                .setBody(simple("null"))
                .removeHeaders("CamelHttp*")
                .setHeader(Exchange.HTTP_METHOD, HttpMethods.GET)
                .setHeader(Exchange.HTTP_URI, simple("http://{{env:RATING_ENDPOINT:rating:8080}}/api/rating/${header.itemId}"))
                .hystrix().id("Rating Service")
                .hystrixConfiguration()
                .executionTimeoutInMilliseconds(5000).circuitBreakerSleepWindowInMilliseconds(10000)
                .end()
                .to("http4://DUMMY2")
                .onFallback()
                .to("direct:ratingFallback")
                .end()
                .choice().when(body().isNull()).to("direct:ratingFallback").end()
                .setHeader("CamelJacksonUnmarshalType", simple(Rating.class.getName()))
                .unmarshal().json(JsonLibrary.Jackson, Rating.class);

        from("direct:ratingFallback")
                .id("ratingFallbackRoute")
                .transform()
                .constant(new Rating("0", 2.0, 1))
                .marshal().json(JsonLibrary.Jackson, Rating.class);

    }

    private class InventoryEnricher implements AggregationStrategy {
        @Override
        public Exchange aggregate(Exchange original, Exchange resource) {

            // Add the discovered availability to the product and set it back
            Product p = original.getIn().getBody(Product.class);
            Inventory i = resource.getIn().getBody(Inventory.class);
            original.getOut().setBody(p);
            log.info("------------------->"+p);
            
            return original;

        }
    }

    private class RatingEnricher implements AggregationStrategy {
        @Override
        public Exchange aggregate(Exchange original, Exchange resource) {

            // Add the discovered availability to the product and set it back
            Product p = original.getIn().getBody(Product.class);
            Rating r = resource.getIn().getBody(Rating.class);
            original.getOut().setBody(p);
            return original;

        }
    }

}
