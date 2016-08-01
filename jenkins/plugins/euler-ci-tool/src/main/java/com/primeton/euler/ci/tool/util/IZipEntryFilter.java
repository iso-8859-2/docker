/**
 * 
 */
package com.primeton.euler.ci.tool.util;

import java.util.zip.ZipEntry;

/**
 * zipEntry过滤器接口
 *
 * @author wuyuhou
 *
 */
public interface IZipEntryFilter {
	boolean accept(ZipEntry zipEntry);
}