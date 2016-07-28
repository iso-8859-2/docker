/**
 * 
 */
package com.primeton.euler.autoinject.utils;

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