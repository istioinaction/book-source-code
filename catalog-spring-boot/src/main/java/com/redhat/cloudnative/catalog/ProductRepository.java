package com.redhat.cloudnative.catalog;

import org.springframework.context.annotation.Profile;
import org.springframework.data.repository.CrudRepository;

@Profile("!v2")
public interface ProductRepository extends CrudRepository<Product, String> {
}
