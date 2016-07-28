/*******************************************************************************
 *
 *==============================================================================
 *
 * Copyright (c) 2001-2016 Primeton Technologies, Ltd.
 * All rights reserved.
 * 
 * Created on 2016年6月1日 下午2:32:07
 *******************************************************************************/


package com.primeton.euler.autoinject.core;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Properties;
import java.util.Set;
import java.util.zip.ZipEntry;

import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import com.primeton.euler.autoinject.utils.IOUtil;
import com.primeton.euler.autoinject.utils.IZipEntryFilter;

/**
 * 配置注入
 *
 * @author wuyuhou (mailto:wuyuhou@primeton.com)
 */
public class AutoConfigInjection {
	
	private static final String AUTOCONFIG_FILE = "auto-config.xml";
	
	private static final String FILE_ENCODING = "UTF-8";
	
	private static final String[] ZIP_FILES = new String[]{
			".jar", ".zip", ".war", ".ear"};
	
	//要配置的压缩包路径
	private File zipPath;
	
	//配置注入属性URL
	private URL propertyURL;
	
	//配置值集合
	private Properties configProperties;
	
	public File getZipPath() {
		return zipPath;
	}

	public void setZipPath(File zipPath) {
		this.zipPath = zipPath;
	}

	public URL getPropertyURL() {
		return propertyURL;
	}

	public void setPropertyURL(URL propertyURL) {
		this.propertyURL = propertyURL;
	}
	
	/**
	 * Default. <br>
	 */
	public AutoConfigInjection() {
		super();
	}

	/**
	 * @param zipPath
	 * @param propertyURL
	 */
	public AutoConfigInjection(File zipPath, URL propertyURL) {
		super();
		this.zipPath = zipPath;
		this.propertyURL = propertyURL;
	}

	/**
	 * @param zipPath
	 * @param configProperties
	 */
	public AutoConfigInjection(File zipPath, Properties configProperties) {
		super();
		this.zipPath = zipPath;
		this.configProperties = configProperties;
	}

	/**
	 * 配置注入
	 */
	public int inject() throws Exception {
		if (zipPath == null) {
			System.err.println("Warn: Zip Path is null!");
			return -1;
		}
		if (propertyURL == null && configProperties == null) {
			System.err.println("Warn: PropertyURL and configProperties is null!");
			return -1;
		}
		if (!zipPath.exists()) {
			System.err.println("Warn: Zip Path is not existed!" + zipPath.getAbsolutePath());
			return -1;
		}
		// Modify by ZhongWen 增加条件判断
		if (null != propertyURL) {
			configProperties = new Properties();
			InputStream propertyInput = null;
			try {
				propertyInput = propertyURL.openStream();
				configProperties.load(propertyInput);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				IOUtil.closeQuietly(propertyInput);
			}
		}
		
		System.out.println("#######################Config Properties Value start#######################");
		Object[] keyArray = configProperties.keySet().toArray();
		Arrays.sort(keyArray);
		
		// Modify by ZhongWen 增加条件判断
		if (null != propertyURL) {
			//中文编码转换
			for (Object key : keyArray) {
				Object value = configProperties.get(key);
				if (value != null) {
					configProperties.put(key, new String(String.valueOf(value).getBytes("ISO-8859-1"), FILE_ENCODING));
				}
				System.out.println(key + "=" + configProperties.get(key));
			}
		} else {
			System.out.println(configProperties);
		}
		System.out.println("#######################Config Properties Value end#######################");
		
		if (zipPath.isFile()) {
			doInjectZipFile(zipPath, configProperties, keyArray);			
		} else {
			doInjectDir(zipPath, configProperties, keyArray);
		}
		return 0;
	}
	
	private List<File> getAllZipFiles(File dir) {
		return IOUtil.listFiles(dir, new FileFilter() {
			public boolean accept(File file) {
				return isZipFile(file.getName());
			}
		});
	}
	
	private boolean isZipFile(String fileName) {
		for (String zipSuffix : ZIP_FILES) {
			if (fileName.endsWith(zipSuffix)) {
				return true;
			}
		}
		return false;
	}
	
	private static DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
	
	static {
		dbf.setIgnoringElementContentWhitespace(true);
	}
	
	//配置注入
	private boolean doInjectZipFile(File zipFile, Properties configProperties, Object[] configKeyArray) throws Exception {
		
		//是否需要处理压缩文件
		boolean isNeedProcessZip = !IOUtil.listZipEntrys(zipFile, new IZipEntryFilter() {
			public boolean accept(ZipEntry zipEntry) {
				if(!zipEntry.isDirectory()) {
					String entryName = zipEntry.getName();
					if (isZipFile(entryName) || entryName.endsWith(AUTOCONFIG_FILE)) {
						return true;
					}
				}
				return false;
			}
		}).isEmpty();
		
		if (!isNeedProcessZip) {
			System.out.println("----Zipfile needn't process!: " + zipFile.getAbsolutePath());
			return false;
		}
		
		System.out.println("----Start:  config inject zipfile: " + zipFile.getAbsolutePath());
		
		boolean hasConfigInject = false;
		
		File jarTempOutputDir = new File(zipFile.getParentFile(), zipFile.getName() + "_temp");
		jarTempOutputDir.mkdir();
		
		try {
			IOUtil.unzip(zipFile, jarTempOutputDir, null);
			
			if (doInjectDir(jarTempOutputDir, configProperties, configKeyArray)) {
				hasConfigInject = true;
			}

		} finally {
			if (hasConfigInject) {
				IOUtil.zip(jarTempOutputDir, zipFile, null);
			}			
			IOUtil.deleteQuietly(jarTempOutputDir);
			
			System.out.println("----Finish config inject zipfile: " + zipFile.getAbsolutePath());
		}
		return hasConfigInject;
	}
	
	private boolean doInjectDir(File autoConfigTargetDir, Properties configProperties, Object[] configKeyArray) throws Exception {
		boolean hasConfigInject = false;
		//查找子压缩文件列表，并处理配置注入
		List<File> subZipFileList = getAllZipFiles(autoConfigTargetDir);
		for (File subZipFile : subZipFileList) {
			boolean hasConfigInjectSub = doInjectZipFile(subZipFile, configProperties, configKeyArray);
			if (hasConfigInjectSub) {
				hasConfigInject = true;
			}
		}
		
		//auto-config.xml，需要存放在META-INF目录下
		File metainfDir = new File(autoConfigTargetDir, "META-INF");
		if (!metainfDir.exists()) {
			metainfDir = search(metainfDir, "/META-INF", false);					
			if (metainfDir == null) {
				System.err.println("Warn: File 'auto-config.xml' is not existed! " + autoConfigTargetDir.getAbsolutePath());
				return hasConfigInject;
			}
		}
		//auto-config.xml
		File autoConfigXml = new File(autoConfigTargetDir, "META-INF/autoconf/" + AUTOCONFIG_FILE);
		if (!autoConfigXml.exists()) {
			autoConfigXml = search(metainfDir, "/" + AUTOCONFIG_FILE, true);					
			if (autoConfigXml == null) {
				System.err.println("Warn: File 'auto-config.xml' is not existed! " + autoConfigTargetDir.getAbsolutePath());
				return hasConfigInject;
			}
		}
		System.out.println("AutoConfigXml: " + autoConfigXml.getAbsolutePath());
		
		//配置定义属性
		Properties configDefineProperties = new Properties();
		//模板文件
		List<String> templateList = new ArrayList<String>();
		//目标文件
		List<String> destFileList = new ArrayList<String>();
		InputStream autoConfigFileInput = null;			
		//读取auto-config.xml
		try {
			autoConfigFileInput = new FileInputStream(autoConfigXml);
			Document document = dbf.newDocumentBuilder().parse(autoConfigFileInput);
			Element rootElement = document.getDocumentElement();
			
			NodeList generateNodeList = rootElement.getElementsByTagName("generate");
			for (int i = 0; i < generateNodeList.getLength(); i++) {
				Element generateElement = (Element)generateNodeList.item(i);
				templateList.add(generateElement.getAttribute("template"));
				destFileList.add(generateElement.getAttribute("destfile"));
			}				
			
			//属性定义读取
			NodeList propertyNodeList = rootElement.getElementsByTagName("property");
			for (int i = 0; i < propertyNodeList.getLength(); i++) {
				Element propertyElement = (Element)propertyNodeList.item(i);
				String key = propertyElement.getAttribute("name");
				String value = propertyElement.getAttribute("defaultValue");
				if (value == null) {
					value = "";
				}
				configDefineProperties.setProperty(key, value);
			}
		} finally {
			IOUtil.closeQuietly(autoConfigFileInput);
		}			
		Object[] keyArray = configDefineProperties.keySet().toArray();
		Arrays.sort(keyArray);
		System.out.println("#######################Config Define Properties Default Value start#######################");
		for (Object key : keyArray) {
			System.out.println(key + "=" + configDefineProperties.get(key));
		}
		System.out.println("#######################Config Define Properties Default Value end#######################");
		
		HashSet<String> configKeyUsedSet = new HashSet<String>();
		//配置注入，字符串替换
		for (int i = 0; i < templateList.size(); i++) {
			boolean hasConfigInjectResult = doInjectFile(autoConfigTargetDir, metainfDir, autoConfigXml, 
					templateList.get(i), destFileList.get(i), configDefineProperties, configProperties, configKeyUsedSet);
			if (hasConfigInjectResult) {
				hasConfigInject = true;
			}
		}
		
		System.out.println("--------------Config Define Properties Default Value Unused start--------------");
		for (Object key : keyArray) {
			if (configKeyUsedSet.contains(key)) {
				continue;
			}
			System.out.println(key + "=" + configDefineProperties.get(key));
		}
		System.out.println("--------------Config Define Properties Default Value Unused end--------------");
		
		System.out.println("--------------Config Properties Value Unused start--------------");
		for (Object key : configKeyArray) {
			if (configKeyUsedSet.contains(key)) {
				continue;
			}
			System.out.println(key + "=" + configProperties.get(key));
		}
		System.out.println("--------------Config Properties Value Unused end--------------");
		return hasConfigInject;
	}
	
	//配置注入，字符串替换
	private boolean doInjectFile(File autoConfigTargetDir, File metainfDir, File autoConfigXml, 
			String template, String destFile, 
			Properties configDefineProperties, Properties configProperties, Set<String> configKeyUsedSet) throws Exception {
		if (template == null || template.length() == 0) {
			System.out.println("Warn: Template is null!");
			return false;
		}
		System.out.println("template: " + template);
		if (destFile == null || destFile.length() == 0) {
			System.out.println("Warn: Dest Config File is null!");
			return false;
		}
		System.out.println("destFile: " + destFile);
		template = IOUtil.normalizeInUnixStyle("/" + template);
		destFile = IOUtil.normalizeInUnixStyle("/" + destFile);
		File templateFile = new File(autoConfigXml.getParentFile(), template);
		if (!templateFile.exists()) {
			templateFile = search(metainfDir, template, true);
			if (templateFile == null) {
				System.out.println("Warn: Template isnot exists!" + template);
				return false;
			}
		}
		System.out.println("templateFile: " + templateFile.getAbsolutePath());
		File destConfigFile = new File(autoConfigTargetDir, destFile);
		// Midify by ZhongWen, 如果父目录不存在，此处会报错
		if (!destConfigFile.getParentFile().exists()) {
			destConfigFile.getParentFile().mkdirs();
		}
		if (!destConfigFile.exists()) {
			destConfigFile.createNewFile();				
		}
		System.out.println("destConfigFile: " + destConfigFile.getAbsolutePath());
		
		StringBuffer templateContent = new StringBuffer();
		BufferedReader templateReader = null;
		try {
			templateReader = new BufferedReader(new InputStreamReader(new FileInputStream(templateFile), FILE_ENCODING));
			String line = null; 
			while ((line = templateReader.readLine()) != null) { 
				templateContent.append(line);
				templateContent.append("\n");
			}
		} finally {
			IOUtil.closeQuietly(templateReader);
		}
		String destConfigContent = replaceAllByProperty(templateContent.toString(), configDefineProperties, configProperties, true, configKeyUsedSet);
		FileOutputStream destFileOutput = null;
		try {
			destFileOutput = new FileOutputStream(destConfigFile, false);
			destFileOutput.write(destConfigContent.getBytes(FILE_ENCODING));
			destFileOutput.flush();
		} finally {
			IOUtil.closeQuietly(destFileOutput);
		}
		return true;
	}
	
	private File search(File dir, String name, boolean isFile) {
		// Modify bi ZhongWen, 增加空判断解,决空指针异常
		if (null == dir || null == name) {
			return null;
		}
		File[] children = dir.listFiles();
		if (null == children || children.length == 0) {
			return null;
		}
		for (File file : children) {
			if (file.isDirectory()) {
				if (!isFile) {
					if (IOUtil.normalizeInUnixStyle(file.getAbsolutePath()).endsWith(name)) {
						return file;
					}
				}
				File result = search(file, name, isFile);
				if (result != null) {
					return result;
				}
			} else {
				if (isFile && IOUtil.normalizeInUnixStyle(file.getAbsolutePath()).endsWith(name)) {
					return file;
				}
			}
		}
		return null;
	}
	
	protected static String DELIM_START = "${";

	protected static char DELIM_STOP = '}';

	protected static int DELIM_START_LEN = 2;

	protected static int DELIM_STOP_LEN = 1;
	
	/**
	 * 取得含有变量的属性信息，使用${var_name}形式，允许递归
	 * 
	 * @param content The string on which variable substitution is performed.
	 * 
	 * @param nestedCall 是否允许递归调用
	 * 
	 * @throws IllegalArgumentException if <code>val</code> is malformed.
	 */
	private static String replaceAllByProperty(String content, Properties configDefineProperties, 
			Properties configProperties, boolean nestedCall, Set<String> configKeyUsedSet) throws IllegalArgumentException {

		StringBuffer sbuf = new StringBuffer();

		int i = 0;
		int j, k;

		while (true) {
			j = content.indexOf(DELIM_START, i);
			if (j == -1) {
				// no more variables
				if (i == 0) { // this is a simple string
					return content;
				} else { // add the tail string which contails no variables and
							// return the result.
					sbuf.append(content.substring(i, content.length()));
					return sbuf.toString();
				}
			} else {
				sbuf.append(content.substring(i, j));
				k = content.indexOf(DELIM_STOP, j);
				if (k == -1) {
					throw new IllegalArgumentException('"' + content + "\" has no closing brace. Opening brace at position " + j + '.');
				} else {
					j += DELIM_START_LEN;
					String key = content.substring(j, k);
					if (configDefineProperties.containsKey(key)) {
						configKeyUsedSet.add(key);
						// first try in System properties
						String replacement = configProperties.getProperty(key);
						// then try props parameter
						if (replacement == null) {
							replacement = configDefineProperties.getProperty(key);
							System.err.println("WARN: '" + key + "' is not config, so use default! defaultValue=" + replacement);
						}
						if (nestedCall) {
							String nestedReplacement = replaceAllByProperty(replacement, configDefineProperties, configProperties, nestedCall, configKeyUsedSet);
							sbuf.append(nestedReplacement);
						} else {
							sbuf.append(replacement);
						}
					} else {		
						System.err.println("WARN: '" + key + "' is not existed defined in auto-config.xml!");
						String replacement = configProperties.getProperty(key);
						if (replacement == null) {
							sbuf.append(DELIM_START + key + DELIM_STOP);
						} else {
							configKeyUsedSet.add(key);
							if (nestedCall) {
								String nestedReplacement = replaceAllByProperty(replacement, configDefineProperties, configProperties, nestedCall, configKeyUsedSet);
								sbuf.append(nestedReplacement);
							} else {
								sbuf.append(replacement);
							}
						}
					}
					i = k + DELIM_STOP_LEN;
				}
			}
		}
	}
}
