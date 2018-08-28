package com.redhat.cloudnative.catalog;

import org.springframework.context.annotation.Profile;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "PRODUCT_V2", uniqueConstraints = @UniqueConstraint(columnNames = "itemId"))
@Profile({"v2"})
public class Productv2 implements Serializable  {

	@Id
	private String itemId;

	private String name;

	private String description;

	private double price;

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
	private boolean discountAvailable;


	public Productv2() {
	}


	@Override
	public String toString() {
		return "Product [itemId=" + getItemId() + ", name=" + getName() + ", price=" + getPrice() +
				", discountAvailable="+discountAvailable+"]";
	}

	public boolean isDiscountAvailable() {
		return discountAvailable;
	}

	public void setDiscountAvailable(boolean discountAvailable) {
		this.discountAvailable = discountAvailable;
	}


	public void discountAvailable() {
		this.discountAvailable=true;
	}
}