/**
 * Copyright (c) 2001-2016 Primeton Technologies, Ltd.
 * All rights reserved. 
 */
package org.me.example;

import java.text.MessageFormat;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author ZhongWen Li (mailto:lizw@primeton.com)
 *
 */
@Controller
public class HelloWorld {
	
	@Autowired
	private AppYaml yaml;
	
	@RequestMapping("/")
	@ResponseBody
	public String index() {
		return System.getProperties().toString();
	}
	
	@RequestMapping("/env")
	@ResponseBody
	public String env() {
		return System.getenv().toString();
	}

	@RequestMapping("/yaml")
	@ResponseBody
	public String yaml() {
		return yaml.toString();
	}
	
	@RequestMapping("/hi/{who}")
	@ResponseBody
	public String hi(@PathVariable("who") String who) {
		return MessageFormat.format("Hi, {0}, time {1}.", who, new Date());
	}
	
}
