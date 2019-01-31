package com.redhat.coolstore.api_gateway.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;

@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
public class Product  {

	public String itemId;
	public String name;
	public String description;
	public double price;
	private Boolean discountAvailable;



	public Product() {

	}
	public Product(String itemId, String name, String desc, double price, Inventory availability) {
		this.itemId = itemId;
		this.name = name;
		this.description = desc;
		this.price = price;
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

	public void setDescription(String desc) {
		this.description = desc;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public String toString() {
		return ("Product toString: name:" + name + " id:" + itemId + " price:" + price + " desc:" + description);
	}

	public Boolean isDiscountAvailable() {
		return discountAvailable;
	}

	public void setDiscountAvailable(Boolean discountAvailable) {
		this.discountAvailable = discountAvailable;
	}
}
