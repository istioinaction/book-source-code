package com.redhat.cloudnative.catalog;

import org.springframework.context.annotation.Profile;

import java.io.Serializable;

import javax.persistence.*;


@Entity
@Table(name = "PRODUCT", uniqueConstraints = @UniqueConstraint(columnNames = "itemId"))
@Profile("!v2")
public class Product implements Serializable {
	
	@Id
	private String itemId;
	
	private String name;
	
	private String description;
	
	private double price;

	public Product() {
	}
	
	public String getItemId() {
		return itemId;
	}

	public void setItemId(String itemId) {
		this.itemId = itemId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	@Override
	public String toString() {
		return "Product [itemId=" + itemId + ", name=" + name + ", price=" + price + "]";
	}
}