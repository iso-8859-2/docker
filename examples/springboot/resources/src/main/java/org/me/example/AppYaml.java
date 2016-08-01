/**
 * Copyright (c) 2001-2016 Primeton Technologies, Ltd.
 * All rights reserved. 
 */
package org.me.example;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

/**
 * @author ZhongWen Li (mailto:lizw@primeton.com)
 *
 */
@Configuration
public class AppYaml {
	
	@Value("${module1.v1}")
	private String v11;
	
	@Value("${module1.v2}")
	private String v12;
	
	@Value("${module1.v3}")
	private String v13;
	
	@Value("${module2.v1}")
	private String v21;
	
	@Value("${module2.v2}")
	private String v22;
	
	@Value("${module2.v3}")
	private String v23;

	/**
	 * Default. <br>
	 */
	public AppYaml() {
		super();
	}

	/**
	 * @return the v11
	 */
	public String getV11() {
		return v11;
	}

	/**
	 * @param v11 the v11 to set
	 */
	public void setV11(String v11) {
		this.v11 = v11;
	}

	/**
	 * @return the v12
	 */
	public String getV12() {
		return v12;
	}

	/**
	 * @param v12 the v12 to set
	 */
	public void setV12(String v12) {
		this.v12 = v12;
	}

	/**
	 * @return the v13
	 */
	public String getV13() {
		return v13;
	}

	/**
	 * @param v13 the v13 to set
	 */
	public void setV13(String v13) {
		this.v13 = v13;
	}

	/**
	 * @return the v21
	 */
	public String getV21() {
		return v21;
	}

	/**
	 * @param v21 the v21 to set
	 */
	public void setV21(String v21) {
		this.v21 = v21;
	}

	/**
	 * @return the v22
	 */
	public String getV22() {
		return v22;
	}

	/**
	 * @param v22 the v22 to set
	 */
	public void setV22(String v22) {
		this.v22 = v22;
	}

	/**
	 * @return the v23
	 */
	public String getV23() {
		return v23;
	}

	/**
	 * @param v23 the v23 to set
	 */
	public void setV23(String v23) {
		this.v23 = v23;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "AppYaml [v11=" + v11 + ", v12=" + v12 + ", v13=" + v13 + ", v21=" + v21 + ", v22=" + v22 + ", v23="
				+ v23 + "]";
	}
	
}
