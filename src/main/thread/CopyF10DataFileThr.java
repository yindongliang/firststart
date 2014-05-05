package main.thread;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.channels.FileChannel;
import java.util.List;
import java.util.Map;

public class CopyF10DataFileThr extends Thread {

	Map<Integer, String> mpcnt;
	int i;

	List<File> filels;
	String targetFolder;

	public void run() {

		// File[] files = Filels.listFiles();
		for (int i = 0; i < filels.size(); i++) {
			String fn = filels.get(i).getName();
			if (fn.startsWith("00") || fn.startsWith("30")
					|| fn.startsWith("60")) {
				if (fn.endsWith(".013") || fn.endsWith(".010")
						|| fn.endsWith(".001")) {
					copyFile(filels.get(i).getAbsolutePath(), targetFolder + fn);
//					fileChannelCopy(filels.get(i),new File(targetFolder + fn));
					System.out.println(targetFolder + fn);
				}
			}

		}
		mpcnt.put(i, "");
	}

	public void fileChannelCopy(File s, File t) {

		FileInputStream fi = null;

		FileOutputStream fo = null;

		FileChannel in = null;

		FileChannel out = null;

		try {

			fi = new FileInputStream(s);

			fo = new FileOutputStream(t);

			in = fi.getChannel();// 得到对应的文件通道

			out = fo.getChannel();// 得到对应的文件通道

			in.transferTo(0, in.size(), out);// 连接两个通道，并且从in通道读取，然后写入out通道

		} catch (IOException e) {

			e.printStackTrace();

		} finally {

			try {

				fi.close();

				in.close();

				fo.close();

				out.close();

			} catch (IOException e) {

				e.printStackTrace();

			}

		}

	}

	public void copyFile(String oldPath, String newPath) {
		try {

			int byteread = 0;
			File oldfile = new File(oldPath);
			if (oldfile.exists()) { // 文件存在时
				InputStream inStream = new FileInputStream(oldPath); // 读入原文件
				FileOutputStream fs = new FileOutputStream(newPath);
				byte[] buffer = new byte[1444];

				while ((byteread = inStream.read(buffer)) != -1) {

					fs.write(buffer, 0, byteread);
				}
				inStream.close();
				fs.close();
			}
		} catch (Exception e) {

			e.printStackTrace();

		}

	}

	public void setData(Map<Integer, String> mpcnt, int i, List<File> filels,
			String targetFolder) {

		this.filels = filels;
		this.mpcnt = mpcnt;
		this.targetFolder = targetFolder;
		this.i = i;
	}

}
