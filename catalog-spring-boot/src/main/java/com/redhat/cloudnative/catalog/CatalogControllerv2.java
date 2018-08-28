package com.redhat.cloudnative.catalog;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Profile;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.Map;
import java.util.Spliterator;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

@Profile("v2")
@Controller
@RequestMapping(value = "/api/catalog")
public class CatalogControllerv2 {


	  @Autowired
      private ProductRepositoryv2 repositoryv2;


    @ResponseBody
    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    public List<Productv2> getAll(@RequestHeader Map<String, String> headers) {
        FailureGenerator.checkFailure(headers);

        Spliterator<Productv2> products = repositoryv2.findAll().spliterator();
        return StreamSupport.stream(products, false)
                .collect(Collectors.toList());

    }
}