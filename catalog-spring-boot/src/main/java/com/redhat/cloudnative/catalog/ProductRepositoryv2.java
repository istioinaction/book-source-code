package com.redhat.cloudnative.catalog;

import org.springframework.context.annotation.Profile;
import org.springframework.data.repository.CrudRepository;

@Profile({"v2", "!default"})
public interface ProductRepositoryv2 extends CrudRepository<Productv2, String> {
}
