/*******************************************************************************
 *
 * =============================================================================
 * =
 *
 * Copyright (c) 2001-2016 Primeton Technologies, Ltd. All rights reserved.
 * 
 * Created on 2016年7月13日 下午4:03:30
 *******************************************************************************/

package com.primeton.euler.ci.tool;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.HashSet;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.primeton.euler.ci.tool.util.IOUtil;

/**
 * POM文件从SNAPSHOT转变为Release入口类
 *
 * @author wuyuhou (mailto:wuyuhou@primeton.com)
 */
public class PomReleaseConvertMain {
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		convert(args);
	}
	
	private static DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
	
	static {
		dbf.setIgnoringElementContentWhitespace(true);
	}
	
	private static final String SNAPSHOT = "-SNAPSHOT";
	
	/**
	 * 使用-D参数（POM_FILE）进行配置
	 * <br>
	 * 例如：
	 *   -DPOM_FILE="c:/download/pom.xml"
	 * 
	 * @param args
	 */
	private static void convert(String[] args) {
		long beginTime = System.currentTimeMillis();
		int returnCode = 0;
		System.out.println("*************************Starting POM Convert*************************");
		try {
			String strPomFile = System.getProperty("POM_FILE");
			if (strPomFile == null || strPomFile.length() == 0) {
				System.err.println("ERROR: POM_FILE is null!");
				returnCode = -1;
			}
			System.out.println("POM_FILE: " + strPomFile);
			
			try {
				File pomFile = new File(strPomFile);
				boolean isChange = false;
				InputStream input = null;
				Document document = null;
				try {
					input = new FileInputStream(pomFile);
					document = dbf.newDocumentBuilder().parse(input);
					HashSet<String> groupIdSet = new HashSet<String>();
					Element rootElement = document.getDocumentElement();
					
					Element parentElement = getElement(rootElement, "parent");
					if (parentElement != null) {
						Element parentGroupIdElement = getElement(parentElement, "groupId");
						if (parentGroupIdElement != null) {
							String groupId = getNodeValue(parentGroupIdElement);
							if (groupId != null) {
								groupIdSet.add(groupId.trim());
							}
						}
						if (convertVersion(parentElement)) {
							isChange = true;
						}
					}

					Element groupIdElement = getElement(rootElement, "groupId");
					if (groupIdElement != null) {
						String groupId = getNodeValue(groupIdElement);
						if (groupId != null) {
							groupIdSet.add(groupId.trim());
						}
					}
					
					if (convertVersion(rootElement)) {
						isChange = true;
					}
					
					NodeList dependencyNodeList = rootElement.getElementsByTagName("dependency");
					for (int i = 0; i < dependencyNodeList.getLength(); i++) {
						Element dependencyElement = (Element)dependencyNodeList.item(i);
						Element groupIdDependElement = getElement(dependencyElement, "groupId");
						if (groupIdDependElement != null) {
							String groupId = getNodeValue(groupIdDependElement);
							if (groupId != null) {
								if (groupIdSet.contains(groupId.trim())) {
									if (convertVersion(dependencyElement)) {
										isChange = true;
									}
								}
							}
						}
					}
				} finally {
					IOUtil.closeQuietly(input);
				}
				if (isChange) {
					TransformerFactory transFactory=TransformerFactory.newInstance();
					Transformer transformer = transFactory.newTransformer();
					transformer.setOutputProperty("indent", "no");
					DOMSource source =new DOMSource();
					source.setNode(document);
					StreamResult result = new StreamResult();
					FileOutputStream output = null;
					try {
						output = new FileOutputStream(pomFile);
						result.setOutputStream(output);
						transformer.transform(source, result);
					} finally {
						IOUtil.closeQuietly(input);
					}
				}
			} catch (Throwable t) {
				System.err.println("ERROR:" + t.getMessage());
				t.printStackTrace();
				returnCode = 99;
			}
		} finally {
			System.out.println(AutoConfigMain.getDuration(
	                "##########Total time：{0,choice,0#|.1#{0,number,integer} min}, {1,choice,0#|.1#{1,number,integer} sec}, {2,number,integer} ms.",
	                System.currentTimeMillis() - beginTime));
			System.exit(returnCode);
		}
	}
	
	private static boolean convertVersion(Element element) {
		Element versionElement = getElement(element, "version");
		if (versionElement != null) {
			String version = getNodeValue(versionElement);
			if (version.indexOf(SNAPSHOT) != -1) {
				version = version.replaceAll(SNAPSHOT, "");
				setNodeValue(versionElement, version);
				return true;
			}
		}
		return false;
	}
	
	private static Element getElement(Element parentElement, String subElementTag) {
		if (parentElement == null) {
			return null;
		}
		NodeList nl = parentElement.getChildNodes();
		for (int i = 0; i < nl.getLength(); i++) {
			if (nl.item(i).getNodeType() == Node.ELEMENT_NODE) {
				if (nl.item(i).getNodeName().equals(subElementTag)) {
					return (Element) nl.item(i);
				}
			}
		}
		return null;
	}
	
	/**
	 * 从Element Node中获得value
	 * @param Node node
	 * @return String
	 */
	private static String getNodeValue(Node node) {
		String value = null;
		if (node == null) {
			return null;
		}
		else {
			switch (node.getNodeType()) {
				case (Node.ELEMENT_NODE):
					StringBuffer contents = new StringBuffer();
					NodeList childNodes = node.getChildNodes();
					int length = childNodes.getLength();
					if (length == 0) {
						return null;
					}
					for (int i = 0; i < length; i++) {
						if (childNodes.item(i).getNodeType() == Node.TEXT_NODE) {
							contents.append(childNodes.item(i).getNodeValue());
						}
					}
					value = contents.toString();
					break;
				case (Node.TEXT_NODE):
					value = node.getNodeValue();
					break;
				case (Node.ATTRIBUTE_NODE):
					value = node.getNodeValue();
					break;
			}
		}
		if (value == null) {
			return null;
		}
		StringBuffer result = new StringBuffer();
		for (int i = 0; i < value.length(); i++) {
			char c = value.charAt(i);
				result.append(c);
		}
		return result.toString().trim();
	}
	
	private static void setNodeValue(Node node, String value) {
		if (node == null) {
			return;
		}
		else {
			Node childNode = null;
			switch (node.getNodeType()) {
				case (Node.ELEMENT_NODE):
					childNode = node.getFirstChild();
					if (childNode == null) {
						childNode = node.getOwnerDocument().createTextNode(value);
						node.appendChild(childNode);
					}
					else if (childNode.getNodeType() == Node.TEXT_NODE) {
						childNode.setNodeValue(value);
					}
					else {
						node.appendChild(node.getOwnerDocument().createTextNode(value));
					}
					return;
				case (Node.TEXT_NODE):
					node.setNodeValue(value);
					return;
				case (Node.ATTRIBUTE_NODE):
					node.setNodeValue(value);
					return;
			}
		}
	}
}
