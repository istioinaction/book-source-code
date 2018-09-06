package com.redhat.cloudnative.catalog;

import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Spliterator;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Profile;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Profile("!v2")
@Controller
@RequestMapping(value = "/api/catalog")
public class CatalogController {

    @Autowired
    private ProductRepository repository;


    @ResponseBody
    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    public List<Product> getAll(@RequestHeader Map<String, String> headers) {

        System.out.println("Got a request with headers: " +
                HeadersPrinter.asSingleLineString(headers)
        );

        FailureGenerator.checkFailure(headers);

        Spliterator<Product> products = repository.findAll().spliterator();
        return StreamSupport.stream(products, false).collect(Collectors.toList());
    }
}