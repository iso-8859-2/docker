/**
 * Copyright (c) 2001-2016 Primeton Technologies, Ltd.
 * All rights reserved. 
 */
package org.me.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * @author ZhongWen Li (mailto:lizw@primeton.com)
 *
 */
@SpringBootApplication
@EnableAutoConfiguration
public class Application {

	public static void main(String[] args) {
		 SpringApplication.run(Application.class, args);
	}
	
}
