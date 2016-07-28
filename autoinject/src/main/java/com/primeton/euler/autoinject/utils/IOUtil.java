package com.primeton.euler.autoinject.utils;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.Closeable;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Method;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.zip.CRC32;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipOutputStream;

/**
 * 
 * IO操作工具类
 */
public final class IOUtil {
	
	private static final String OS_NAME = System.getProperty("os.name").toLowerCase(Locale.US);
	
    private static final boolean ON_WINDOWS = OS_NAME.indexOf("windows") > -1;
    
    private static final int DELETE_RETRY_SLEEP_MILLIS = 10;
	
	public static final FileFilter LIST_FILE = new FileFilter() {

		public boolean accept(File file) {
			if (file == null) {
				return false;
			}
			if (!file.isDirectory()) {
				return true;
			}
			return false;
		}
	};
	
	public static final FileFilter LIST_DIR = new FileFilter() {
		public boolean accept(File file) {
			if (file == null) {
				return false;
			}
			if (file.isDirectory()) {
				return true;
			}
			return false;
		}
	};
	
	public static final IZipEntryFilter LIST_ZIP_ENTRY_FILE = new IZipEntryFilter() {

		public boolean accept(ZipEntry zipEntry) {
			if (zipEntry == null) {
				return false;
			}
			if (!zipEntry.isDirectory()) {
				return true;
			}
			return false;
		}
	};
	
	public static final IZipEntryFilter LIST_ZIP_ENTRY_DIR = new IZipEntryFilter() {
		public boolean accept(ZipEntry zipEntry) {
			if (zipEntry == null) {
				return false;
			}
			if (zipEntry.isDirectory()) {
				return true;
			}
			return false;
		}
	};

	/**
	 * 安静的关闭
	 * 
	 * @param ioObj
	 */
	public static void closeQuietly(Object ioObj) {
		if (ioObj == null) {
			return;
		}
		
		if (ioObj instanceof Closeable) {
			try {
				((Closeable)ioObj).close();
				return;
			} catch (Throwable ignore) {
			}
		} else {
			try {
				Method method = ioObj.getClass().getMethod("close", new Class[0]);
				if (method != null) {
					method.invoke(ioObj, new Object[0]);
					return;
				}				
			} catch (Throwable ignore) {
			}
			throw new IllegalArgumentException("ioObj'" + ioObj.getClass() + "' is not support type!");
		}
	}

	/**
	 * 是否是绝对路径（根据当前系统判断）
	 * 
	 * @param path 路径
	 * @return true:是
	 */
	public static boolean isAbsolutePath(String path) {
		if (path == null || path.trim().length() == 0) {
			throw new IllegalArgumentException("path is null!");
		}
		path = normalizeInUnixStyle(path);		
	    if (isWindowsAndDos()) {
	    	int colon = path.indexOf(":/");
	        return Character.isLetter(path.charAt(0)) && colon == 1;
	    } else {
	    	return path.charAt(0) == '/';
	    }
	}
	
	private static boolean isWindowsAndDos() {
		if (OS_NAME.indexOf("windows") > -1) {
			return true;
		}
		if (OS_NAME.indexOf("dos") > -1) {
			return true;
		}
		if (OS_NAME.indexOf("netware") > -1) {
			return true;
		}
		return false;
	}
	
	/**
	 * 取得文件名
	 * 
	 * @param filePath 文件路径
	 * @param isWithFileExtension 是否包含文件扩展名
	 * @return 文件名
	 */
	public static String getFileName(String filePath, boolean isWithFileExtension) {
		if (filePath == null || filePath.trim().length() == 0) {
			throw new IllegalArgumentException("file is null!");
		}
		filePath = filePath.trim();
		int index = filePath.lastIndexOf('/');
		int index2 = filePath.lastIndexOf('\\');
		if (index2 > index) {
			index = index2;
		}
		
		String fileName = filePath;
		if (index != -1) {
			fileName = filePath.substring(index + 1);
		}
		if (!isWithFileExtension) {
			index = fileName.lastIndexOf('.');
			if (index != -1) {
				fileName = fileName.substring(0, index);
			}
		}
		
		return fileName.trim();
	}

	/**
	 * 取得文件扩展名
	 * 
	 * @param filePath 文件路径
	 * @return 文件扩展名
	 */
	public static String getFileExtension(String filePath) {
		if (filePath == null || filePath.trim().length() == 0) {
			return null;
		}
		filePath = filePath.trim();
		int index = filePath.lastIndexOf('.');
		if (index != -1) {
			return filePath.substring(index + 1).trim();
		}
		return null;
	}
	
	/**
	 * 得到相对路径<br>
	 * 
	 * 如c:/abc/de/a.txt相对于c:/abc的相对路径是de/a.txt<BR>
	 * 
	 * @param rootPath
	 * @param resourcePath
	 * @return
	 */
	public static String getRelativePath(String rootPath, String resourcePath) {
		if (rootPath == null || rootPath.trim().length() == 0) {
			throw new IllegalArgumentException("rootPath is null!");
		}
		if (resourcePath == null || resourcePath.trim().length() == 0) {
			throw new IllegalArgumentException("resourcePath is null!");
		}
		rootPath = normalizeInUnixStyle(rootPath);
		resourcePath = normalizeInUnixStyle(resourcePath);
		if (!resourcePath.startsWith(rootPath)) {
			throw new IllegalArgumentException("rootPath'" + rootPath + "' is not resourcePath'" + resourcePath + "' root!");
		}
		String relativePath = resourcePath.substring(rootPath.length());
		if (relativePath.length() > 0 && relativePath.charAt(0) == '/') {
			relativePath = relativePath.substring(1);
		}
		return relativePath;
	}	

	/**
	 * 转化为Unix风格的标准格式路径<br>
	 * 
	 * 如com//sun\jnlp\<BR>
	 * 就会变成com/sun/jnlp。<BR>
	 * 
	 * @param path 路径
	 * @return
	 */
	public static String normalizeInUnixStyle(String path) {
		if (path == null || path.trim().length() == 0) {
			throw new IllegalArgumentException("path is null!");
		}
		path = path.trim();
		String head = "";
		char headChar = path.charAt(0);
		if (headChar == '/' || headChar == '\\') {
			head = "/";
			path = path.substring(1);
		}
		int index = path.indexOf(':');
		if (index != -1) {
			head = path.substring(0, index + 1) + "/";
			path = path.substring(index + 2);
		}
		String[] tokens = toPathTokens(path);
		StringBuilder buf = new StringBuilder();
		int parentCount = 0;
		for (int i = tokens.length - 1; i >= 0; i--) {
			if (tokens[i].equals(".")) {
				continue;
			}
			if (tokens[i].equals("..")) {
				parentCount++;
			} else {
				if (parentCount == 0) {
					buf.insert(0, "/" + tokens[i]);
				} else {
					parentCount--;
				}
			}
		}
		
		String result = null;
		if (buf.length() > 0) {
			result = buf.substring(1);
		} else {
			result = ".";
		}
		if (parentCount > 0) {
			buf = new StringBuilder();
			while(parentCount > 0) {
				buf.append("../");
				parentCount--;
			}
			result = buf.toString() + result;
		}

		if (head.length() > 0) {
			result = head + result;
		}
		return result;
	}
	
	private static String[] toPathTokens(String path) {
		List<String> tokenList = new ArrayList<String>();
		StringBuilder buf = new StringBuilder();
		for (int i = 0; i < path.length(); i++) {
			String ele = path.substring(i, i + 1);
			if (ele.equals("/") || ele.equals("\\")) {
				String token = buf.toString().trim();
				if (token.length() > 0) {
					tokenList.add(token);
				}
				buf = new StringBuilder();
			} else {
				buf.append(ele);
			}
		}
		String token = buf.toString().trim();
		if (token.length() > 0) {
			tokenList.add(token);
		}
		return tokenList.toArray(new String[0]);
	}

	/**
	 * 删除文件或者目录
	 * 
	 * @param path 字符串或者java.io.File类型
	 */
	public static boolean deleteQuietly(Object path) {
		return deleteQuietly(path, false);
	}

	/**
	 * 删除文件或者目录
	 * 
	 * @param path
	 * @param isDeleteEmptyParent 是否删除空的父目录
	 */
	public static boolean deleteQuietly(Object path, boolean isDeleteEmptyParent) {
		if(path == null) {
			return true;
		}
		File deleteFile = null;
		if (path instanceof String) {
			if (((String)path).trim().length() == 0) {
				return true;
			}
			deleteFile = new File((String)path);
		} else if (path instanceof File) {
			deleteFile = (File)path;
		} else {
			throw new IllegalArgumentException("file'" + path.getClass() + "' is not support type!");
		}
		
		try {
			File parent = deleteFile.getParentFile();
			boolean result = doDeleteQuietly(deleteFile);
			
			if (isDeleteEmptyParent) {
				boolean res = doDeleteEmptyParentQuietly(parent);
				if (result) {
					result = res;
				}
			}
			return result;
		} catch (Throwable ignore) {
			return false;
		}
	}
	
	//向下删除
	private static boolean doDeleteQuietly(File file) {
		try {
			boolean result = true;
			if (file.isDirectory()) {
				for (File aFile : file.listFiles()) {
					boolean res = doDeleteQuietly(aFile);	
					if (result) {
						result = res;
					}
				}
			}
			if (result) {
				result = tryHardToDelete(file);
			}			
			return result;
		} catch (Throwable ignore) {
			return false;
		}
	}
	
	//向上删除
	private static boolean doDeleteEmptyParentQuietly(File parent) {
		try {
			if (parent == null) {
				return true;
			}
			boolean result = true;
			File parentFile = parent.getParentFile();
			if (parent.list().length == 0) {
				tryHardToDelete(parent);
				boolean res = doDeleteEmptyParentQuietly(parentFile);
				if (result) {
					result = res;
				}
			}
			return result;
		} catch (Throwable ignore) {
			return false;
		}
	}
	
	private static boolean tryHardToDelete(File f) {
        if (!f.delete()) {
            if (ON_WINDOWS) {
                System.gc();
            }
            try {
                Thread.sleep(DELETE_RETRY_SLEEP_MILLIS);
            } catch (InterruptedException ex) {
                // Ignore Exception
            }
            return f.delete();
        }
        return true;
    }

	/**
	 * 列出目录下的所有文件和目录
	 * 
	 * @param dir
	 * @param filter
	 * @return
	 */
	public static List<File> listFiles(File dir, FileFilter filter) {
		if (dir == null) {
			throw new IllegalArgumentException("dir is null!");
		}
		if (!dir.exists()) {				
			throw new IllegalArgumentException("Path'" + dir.getAbsolutePath() + "' is not existed!");
		}
		if (dir.isFile()) {
			throw new IllegalArgumentException("Path'" + dir.getAbsolutePath() + "' is file, not dir!");
		}
		List<File> fileList = new ArrayList<File>();
		doListFiles(dir, fileList, filter);
		return fileList;
	}
	
	private static void doListFiles(File dir, List<File> fileList, FileFilter filter) {
		for (File file : dir.listFiles()) {
			if (file.isDirectory()) {
				doListFiles(file, fileList, filter);
			}
			if (filter != null && !filter.accept(file)) {
				continue;
			}
			fileList.add(file);
		}
	}
	
	private static final int DEFAULT_BUFFER_SIZE = 1024 * 4;	

	/**
	 * 输入流和输出流的拷贝
	 * 
	 * @param input 输入
	 * @param output 输出
	 * @param bufferSize 缓冲区大小
	 * @return 拷贝字节数
	 * @throws IOException
	 */
	public static long copy(InputStream input, OutputStream output, int bufferSize) throws IOException {
		return copy(input, output, bufferSize, -1);
	}
	
	/**
	 * 输入流和输出流的拷贝
	 * 
	 * @param input 输入
	 * @param output 输出
	 * @param bufferSize 缓冲区大小
	 * @param maxCount 拷贝的最大字节数
	 * @return 拷贝字节数
	 * @throws IOException
	 */
	public static long copy(InputStream input, OutputStream output, int bufferSize, long maxCount) throws IOException {
		if (input == null) {
			throw new IllegalArgumentException("InputStream is null!");
		}
		if (output == null) {
			throw new IllegalArgumentException("OutputStream is null!");
		}
		if (bufferSize <= 0) {
			bufferSize = DEFAULT_BUFFER_SIZE;
		}
		//使用nio
		ReadableByteChannel readChannel = Channels.newChannel(input);
		WritableByteChannel writeChannel = Channels.newChannel(output);
		ByteBuffer buffer = ByteBuffer.allocate(bufferSize);
		long count = 0;
		while (true) {
			if (maxCount > 0) {
				long remainCount = maxCount - count;
				if (remainCount <= 0) {
					break;
				}
				if (remainCount < bufferSize) {
					buffer = ByteBuffer.allocate((int) remainCount);
				}
			}

			if (readChannel.read(buffer) == -1) {
				break;
			}
			buffer.flip(); // Prepare for writing
			writeChannel.write(buffer);
			count += buffer.position();
			buffer.clear(); // Prepare for reading
		}
		return count;
	}

	/**
	 * 文件拷贝(如果有相同的文件，会覆盖掉)；目标路径如果不存在，会自动创建
	 * 
	 * @param srcPath 源路径
	 * @param destPath 目标路径
	 * @param srcFileFilter 源路径过滤规则
	 * @param preserveFileDate 是否保留文件时间戳
	 * @throws IOException
	 */
	public static void copy(File srcPath, File destPath, FileFilter srcFileFilter, boolean preserveFileDate) throws IOException {
		if (srcPath == null) {
			throw new IllegalArgumentException("srcPath is null!");
		}
		if (!srcPath.exists()) {
			throw new IllegalArgumentException("srcPath'" + srcPath.getAbsolutePath() + "' is not existed!");
		}
		if (destPath == null) {
			throw new IllegalArgumentException("destPath is null!");
		}
		//如果两个路径相同，则不需要处理
		if (srcPath.equals(destPath)) {
			return;
		}
		//如果目标路径是源路径的子目录
		if (srcPath.isDirectory() && normalizeInUnixStyle(destPath.getAbsolutePath()).startsWith(normalizeInUnixStyle(srcPath.getAbsolutePath()))) {
			throw new IllegalArgumentException("cannot copy '" + srcPath.getAbsolutePath() + "' to '" + destPath.getAbsolutePath() + "', because srcPath is the parent of destPath.");
		}
		if (!destPath.exists()) {
			destPath.mkdirs();
		}
		if (destPath.isFile()) {
			if (srcPath.isFile()) {				
				doCopyFile(srcPath, destPath, srcFileFilter, preserveFileDate);
			} else {				
				throw new IllegalArgumentException("srcPath'" + srcPath.getAbsolutePath() + "' is dir, destPath'" + srcPath.getAbsolutePath() + "' is file!");
			}
		} else {
			if (srcPath.isFile()) {
				if (srcFileFilter != null) {
					if (!srcFileFilter.accept(srcPath)) {
						return;
					}
				}
				doCopyFile(srcPath, new File(destPath, srcPath.getName()), srcFileFilter, preserveFileDate);
			} else {
				List<File> files = listFiles(srcPath, LIST_FILE);
				String basePath = normalizeInUnixStyle(srcPath.getAbsolutePath());
				for (File srcFile : files) {
					String relativePath = getRelativePath(basePath, srcFile.getAbsolutePath());
					File destFile = new File(destPath, relativePath);
					if (!destFile.getParentFile().exists()) {
						destFile.getParentFile().mkdirs();
					}
					doCopyFile(srcFile, destFile, srcFileFilter, preserveFileDate);
				}
			}
		}
	}
	
	private static void doCopyFile(File srcFile, File destFile, FileFilter srcFileFilter, boolean preserveFileDate) throws IOException {
		if (srcFileFilter != null) {
			if (!srcFileFilter.accept(srcFile)) {
				return;
			}
		}
		FileInputStream input = null;
		FileOutputStream output = null;
		try {					
			input = new FileInputStream(srcFile);
			output = new FileOutputStream(destFile);
			copy(input, output, DEFAULT_BUFFER_SIZE);
			if (preserveFileDate) {
				destFile.setLastModified(srcFile.lastModified());
			}
		} finally {
			closeQuietly(input);
			closeQuietly(output);
		}
	}

	/**
	 * 文件移动(如果有相同的文件，会覆盖掉)；目标路径如果不存在，会自动创建
	 * 
	 * @param srcPath 源路径
	 * @param destPath 目标路径
	 * @param srcFileFilter 源路径过滤规则
	 * @throws IOException
	 */
	public static void move(File srcPath, File destPath, FileFilter srcFileFilter) throws IOException {
		if (srcPath == null) {
			throw new IllegalArgumentException("srcPath is null!");
		}
		if (!srcPath.exists()) {
			throw new IllegalArgumentException("srcPath'" + srcPath.getAbsolutePath() + "' is not existed!");
		}
		if (destPath == null) {
			throw new IllegalArgumentException("destPath is null!");
		}
		//如果两个路径相同，则不需要处理
		if (srcPath.equals(destPath)) {
			return;
		}
		//如果目标路径是源路径的子目录
		if (srcPath.isDirectory() && normalizeInUnixStyle(destPath.getAbsolutePath()).startsWith(normalizeInUnixStyle(srcPath.getAbsolutePath()))) {
			throw new IllegalArgumentException("cannot copy '" + srcPath.getAbsolutePath() + "' to '" + destPath.getAbsolutePath() + "', because srcPath is the parent of destPath.");
		}
		if (!destPath.exists()) {
			destPath.mkdirs();
		}
		if (destPath.isFile()) {
			if (srcPath.isFile()) {				
				doMoveFile(srcPath, destPath, srcFileFilter);
			} else {				
				throw new IllegalArgumentException("srcPath'" + srcPath.getAbsolutePath() + "' is dir, destPath'" + srcPath.getAbsolutePath() + "' is file!");
			}
		} else {
			if (srcPath.isFile()) {
				if (srcFileFilter != null) {
					if (!srcFileFilter.accept(srcPath)) {
						return;
					}
				}
				doMoveFile(srcPath, new File(destPath, srcPath.getName()), srcFileFilter);
			} else {
				List<File> files = listFiles(srcPath, LIST_FILE);
				String basePath = normalizeInUnixStyle(srcPath.getAbsolutePath());
				for (File srcFile : files) {
					String relativePath = getRelativePath(basePath, srcFile.getAbsolutePath());
					File destFile = new File(destPath, relativePath);
					if (!destFile.getParentFile().exists()) {
						destFile.getParentFile().mkdirs();
					}
					doMoveFile(srcFile, destFile, srcFileFilter);
				}
			}
		}
	}
	
	private static void doMoveFile(File srcFile, File destFile, FileFilter srcFileFilter) throws IOException {
		if (srcFileFilter != null) {
			if (!srcFileFilter.accept(srcFile)) {
				return;
			}
		}
		if (destFile.exists()) {
			doDeleteQuietly(destFile);
		}
		if (!srcFile.renameTo(destFile)) {
			doCopyFile(srcFile, destFile, null, true);
			doDeleteQuietly(srcFile);
		}
	}

	/**
	 * 压缩文件
	 * 
	 * @param inputPath 文件或者目录
	 * @param zipFile 压缩后的文件
	 * @param inputFileFilter 源路径过滤规则
	 * @throws IOException
	 */
	public static void zip(File inputPath, File zipFile, FileFilter inputFileFilter) throws IOException {
		if (inputPath == null) {
			throw new IllegalArgumentException("inputPath is null!");
		}
		if (!inputPath.exists()) {
			throw new IllegalArgumentException("inputPath'" + inputPath.getAbsolutePath() + "' is not existed!");
		}
		if (zipFile == null) {
			throw new IllegalArgumentException("zipFile is null!");
		}
		//如果zipFile在inputPath下
		if (normalizeInUnixStyle(zipFile.getAbsolutePath()).startsWith(normalizeInUnixStyle(inputPath.getAbsolutePath()))) {
			throw new IllegalArgumentException("cannot zip '" + inputPath.getAbsolutePath() + "' to '" + zipFile.getAbsolutePath() + "', because inputPath is the parent of zipFile.");
		}
		if (!zipFile.exists()) {
			zipFile.createNewFile();
		} else {
			if (zipFile.isDirectory()) {
				throw new IllegalArgumentException("zipFile'" + zipFile.getAbsolutePath() + "' is dir, not file!");
			}
		}
		
		ZipOutputStream output = null;
		HashSet<String> entrys = new HashSet<String>();
		try {
			output = new ZipOutputStream(new BufferedOutputStream(new FileOutputStream(zipFile)));
			output.setMethod(ZipOutputStream.STORED);
			if (inputPath.isDirectory()) {
				String basePath = inputPath.getAbsolutePath();
				List<File> files = listFiles(inputPath, LIST_FILE);

				Iterator<?> iterator = files.iterator();
				while (iterator.hasNext()) {
					File file = (File) iterator.next();
					if (inputFileFilter != null) {
						if (!inputFileFilter.accept(file)) {
							continue;
						}
					}
					String relativePath = getRelativePath(basePath, file.getAbsolutePath());
					if (relativePath.charAt(0) == '\\' || relativePath.charAt(0) == '/') {
						relativePath = relativePath.substring(1);
					}
					doZip(file, relativePath, output, entrys);
				}
			} else {
				if (inputFileFilter != null) {
					if (!inputFileFilter.accept(inputPath)) {
						return;
					}
				}
				doZip(inputPath, inputPath.getName(), output, entrys);
			}
		} finally {
			try {
				if (output != null) {
					output.flush();
					output.finish();
				}
			} catch (Throwable ignore) {
				
			}
			
			closeQuietly(output);
		}
	}
	
	private static void doZip(File file, String entryName, ZipOutputStream zipOutput, HashSet<String> entrys) throws IOException {	
		CRC32 crc = new CRC32();	
		InputStream input = null;
		try {
			int bytesRead; 
	        byte[] buffer = new byte[1024];
	        try {
				input = new BufferedInputStream(new FileInputStream(file));
	            while ((bytesRead = input.read(buffer)) != -1) { 
	                crc.update(buffer, 0, bytesRead); 
	            } 
	        } finally {
				closeQuietly(input);
			}
			ZipEntry ze = new ZipEntry(entryName);
			entrys.add(ze.getName());						
			ze.setMethod(ZipEntry.STORED); 
			ze.setCompressedSize(file.length()); 
			ze.setSize(file.length()); 
			ze.setCrc(crc.getValue());
			ze.setTime(file.lastModified());
			zipOutput.putNextEntry(ze);
			input = new BufferedInputStream(new FileInputStream(file));
			copy(input, zipOutput, DEFAULT_BUFFER_SIZE);
		} finally {
			closeQuietly(input);
		}
	}

	/**
	 * 解压文件
	 * 
	 * @param zipFile 压缩文件
	 * @param outputDir 解压后的目录
	 * @param zipEntryFilter 过滤规则
	 * @throws IOException
	 */
	@SuppressWarnings("unchecked")
	public static void unzip(File zipFile, File outputDir, IZipEntryFilter zipEntryFilter) throws IOException {
		if (zipFile == null) {
			throw new IllegalArgumentException("zipFile is null!");
		}
		if (!zipFile.exists()) {
			throw new IllegalArgumentException("zipFile'" + zipFile.getAbsolutePath() + "' is not existed!");
		}
		if (outputDir == null) {
			throw new IllegalArgumentException("outputDir is null!");
		}	
		if (!outputDir.exists()) {
			outputDir.mkdirs();
		}
		if (outputDir.isFile()) {
			throw new IllegalArgumentException("outputDir'" + outputDir.getAbsolutePath() + "' is file, not dir!");
		}
		
		ZipFile file = new ZipFile(zipFile);
		try {
			Enumeration<ZipEntry> es = (Enumeration<ZipEntry>)file.entries();
			while (es.hasMoreElements()) {
				ZipEntry entry = (ZipEntry) es.nextElement();
				if (zipEntryFilter != null) {
					if (!zipEntryFilter.accept(entry)) {
						continue;
					}
				}
				File destFile = new File(outputDir, entry.getName());
				if (entry.isDirectory()) {
					if (!destFile.exists()) {
						destFile.mkdirs();
					}
				} else {
					if (!destFile.getParentFile().exists()) {
						destFile.getParentFile().mkdirs();
					}
					if (!destFile.exists()) {
						destFile.createNewFile();
					}
					InputStream input = null;
					OutputStream output = null;
					try {
						input = file.getInputStream(entry);
						output = new FileOutputStream(destFile);
						copy(input, output, DEFAULT_BUFFER_SIZE);
						destFile.setLastModified(entry.getTime());
					} finally {
						closeQuietly(input);
						closeQuietly(output);
					}
				}
			}
		} finally {
			closeQuietly(file);
		}
	}

	/**
	 * 列出压缩文件中的所有文件和目录
	 * 
	 * @param zipFile 压缩文件
	 * @param zipEntryFilter 过滤规则
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static List<ZipEntry> listZipEntrys(File zipFile, IZipEntryFilter zipEntryFilter) throws IOException {
		if (zipFile == null) {
			throw new IllegalArgumentException("zipFile is null!");
		}
		if (!zipFile.exists()) {
			throw new IllegalArgumentException("zipFile'" + zipFile.getAbsolutePath() + "' is not existed!");
		}
		if (zipFile.isDirectory()) {
			throw new IllegalArgumentException("zipFile'" + zipFile.getAbsolutePath() + "' is dir, not file!");
		}
		ZipFile file = new ZipFile(zipFile);
		try {
			List<ZipEntry> fileList = new ArrayList<ZipEntry>();
			Enumeration<ZipEntry> es = (Enumeration<ZipEntry>)file.entries();
			while (es.hasMoreElements()) {
				ZipEntry entry = (ZipEntry) es.nextElement();
				if (zipEntryFilter != null) {
					if (!zipEntryFilter.accept(entry)) {
						continue;
					}
				}
				fileList.add(entry);
			}
			return fileList;
		} finally {
			closeQuietly(file);
		}
	}
}