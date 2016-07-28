/*******************************************************************************
 *
 *==============================================================================
 *
 * Copyright (c) 2001-2016 Primeton Technologies, Ltd.
 * All rights reserved.
 * 
 * Created on 2016年6月1日 下午2:04:28
 *******************************************************************************/


package com.primeton.euler.autoinject;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.MessageFormat;

import com.primeton.euler.autoinject.core.AutoConfigInjection;

/**
 * AutoConfig入口类 (for ci/jenkins)
 *
 * @author wuyuhou (mailto:wuyuhou@primeton.com)
 */
public class AutoConfigMain {
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		doMain(args);
	}
	
	/**
	 * 使用-D参数（PACK_FILE和CONFIG_URL）进行配置
	 * <br>
	 * 例如：
	 *   -DPACK_FILE="c:/download/euler-ci-0.1.0-SNAPSHOT.zip" 
	 *   -DCONFIG_URL="c:/download/test.properties"
	 * 
	 * @param args
	 */
	@SuppressWarnings("deprecation")
	static void doMain(String[] args) {
		long beginTime = System.currentTimeMillis();
		int returnCode = 0;
		System.out.println("*************************Starting Autoconfig*************************");
		try {
			String packFile = System.getProperty("PACK_FILE");
			if (packFile == null || packFile.length() == 0) {
				System.err.println("ERROR: PACK_FILE is null!");
				returnCode = -1;
			}
			System.out.println("PACK_FILE: " + packFile);
			String configURL = System.getProperty("CONFIG_URL");
			if (configURL == null || configURL.length() == 0) {
				System.err.println("ERROR: CONFIG_URL is null!");
				returnCode = -1;
			}
			System.out.println("CONFIG_URL: " + configURL);
			if (returnCode != 0) {
				System.exit(returnCode);
				return;
			}
			try {
				File zipPath = new File(packFile);
				URL propertyURL = null;
				try {
					propertyURL = new URL(configURL);
				} catch (MalformedURLException e) {
					propertyURL = new File(configURL).toURL();
				}
				AutoConfigInjection configInjection = new AutoConfigInjection();
				configInjection.setZipPath(zipPath);
				configInjection.setPropertyURL(propertyURL);
				returnCode = configInjection.inject();
			} catch (Throwable t) {
				System.err.println("ERROR:" + t.getMessage());
				t.printStackTrace();
				returnCode = 99;
			}
		} finally {
			System.out.println(getDuration(
	                "##########总耗费时间：{0,choice,0#|.1#{0,number,integer}分}{1,choice,0#|.1#{1,number,integer}秒}{2,number,integer}毫秒",
	                System.currentTimeMillis() - beginTime));
			System.exit(returnCode);
		}
	}
	
	public static String getDuration(String message, long duration) {
        long ms = duration % 1000;
        long secs = duration / 1000 % 60;
        long min = duration / 1000 / 60;

        return MessageFormat.format(message, new Object[] { new Long(min), new Long(secs), new Long(ms) });
    }
	
}
