package com.redhat.cloudnative.catalog;

import java.util.Collections;
import java.util.List;
import java.util.Map;
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
import org.springframework.web.client.RestTemplate;

@Profile("!v2")
@Controller
@RequestMapping(value = "/api")
public class ForumController {




    @ResponseBody
    @RequestMapping("/users")
    @GetMapping(produces = MediaType.APPLICATION_JSON_VALUE)
    public String getUsers() {

        RestTemplate template = new RestTemplate();
        return template.getForEntity("http://jsonplaceholder.typicode.com/users", String.class).getBody();

    }
}