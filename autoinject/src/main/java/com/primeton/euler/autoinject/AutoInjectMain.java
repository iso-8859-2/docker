/**
 * Copyright (c) 2001-2016 Primeton Technologies, Ltd.
 * All rights reserved. 
 */
package com.primeton.euler.autoinject;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.MessageFormat;
import java.util.Date;
import java.util.Map;
import java.util.Properties;

import com.alibaba.fastjson.JSON;
import com.primeton.euler.autoinject.core.AutoConfigInjection;
import com.primeton.euler.autoinject.utils.IOUtil;

/**
 * Auto inject application configuration while docker run.
 * 
 * @author ZhongWen Li (mailto:lizw@primeton.com)
 *
 */
public class AutoInjectMain {
	
	public static final String P_APP_ENV = "P_APP_ENV";
	public static final String AUTO_INJECT_PATH = "AUTO_INJECT_PATH";
	public static final String APP_ENV_FILE1 = "appconfig.properties";
	public static final String APP_ENV_FILE2 = "appconfig.json";

	/**
	 * -DAUTO_CONF_PATH=${AUTO_CONF_PATH} 
	 * @param args
	 */
	@SuppressWarnings("unchecked")
	public static void main(String[] args) throws Throwable {
		final long begin = System.currentTimeMillis();
		String target = System.getProperty(AUTO_INJECT_PATH);
		String appEnv = System.getenv(P_APP_ENV);
		// mocker data for debug, execute auto-inject in local
		// target = "D:\\test\\app"; // directory
		// target = "D:\\test\\app.war"; // zip file
		// target = "D:\\test\\app.zip"; // zip file
		// target = "D:\\test\\app.jar"; // zip file
		// appEnv = "{'key1':'Hello 中国', 'key2':'你好啊', key3:true, 'key4':123.4}";
		if (null == target || target.trim().isEmpty()) {
			System.err.println(MessageFormat.format("[{0}] [ERROR] JVM environment variable ${1} is empty.",
					new Date()), AUTO_INJECT_PATH);
			return;
		}
		if (null == appEnv || appEnv.trim().isEmpty()) {
			System.err.println(MessageFormat.format("[{0}] [ERROR] OS environment variable ${1} is empty.",
					new Date(), P_APP_ENV));
			return;
		}
		Map<String, Object> elements = JSON.parseObject(appEnv, Map.class);
		final Properties properties = toProperties(elements);
		if (null == properties || properties.isEmpty()) {
			System.err.println(MessageFormat.format("[{0}] [ERROR] OS environment variable ${1} is empty.",
					new Date(). P_APP_ENV));
			return;
		}
		File targetPath = new File(target);
		File envDirectory = new File("/etc/primeton"); //$NON-NLS-1$
		if (!envDirectory.exists()) {
			envDirectory.mkdirs();
		}
		OutputStream os1 = null;
		OutputStream os2 = null;
		try {
			os1 = new FileOutputStream(new File(envDirectory, APP_ENV_FILE1));
			properties.store(os1, "Auto generate by autoconfig."); //$NON-NLS-1$
			
			os2 = new FileOutputStream(new File(envDirectory, APP_ENV_FILE2));
			os2.write(appEnv.getBytes("utf-8")); //$NON-NLS-1$
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			IOUtil.closeQuietly(os1);
			IOUtil.closeQuietly(os2);
		}
		
		AutoConfigInjection injection = new AutoConfigInjection(targetPath, properties);
		int result = injection.inject();
		
		final long end = System.currentTimeMillis();
		System.out.println(MessageFormat.format("[{0}] [INFO ] Auto-config inject finished, spent {1} ms.", //$NON-NLS-1$
				new Date(), (end - begin)));
		
		System.exit(result);
	}
	
	/**
	 * 
	 * @param elements
	 * @return
	 */
	private static Properties toProperties(Map<String, Object> elements) {
		Properties properties = new Properties();
		if (null == elements || elements.isEmpty()) {
			return properties;
		}
		for (String key : elements.keySet()) {
			Object value = elements.get(key);
			properties.setProperty(key, null == value ? "" : value.toString());
		}
		return properties;
	}
	
}
