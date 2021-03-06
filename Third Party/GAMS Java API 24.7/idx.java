/*  Java code generated by apiwrapper for GAMS Version 24.7.4 */
package com.gams.api;

public class idx {
   private long idxPtr = 0;
   public native static int    GetReady (String[] msg);
   public native static int    GetReadyD(String dirName, String[] msg);
   public native static int    GetReadyL(String libName, String[] msg);
   public native int    Create   (String[] msg);
   public native int    CreateD  (String dirName, String[] msg);
   public native int    CreateL  (String libName, String[] msg);
   public native int    Free     ();
   public native int    GetLastError();
   public native void    ErrorStr(int ErrNr, String []ErrMsg);
   public native int    OpenRead(String FileName, int []ErrNr);
   public native int    OpenWrite(String FileName, String Producer, int []ErrNr);
   public native int    Close();
   public native int    GetSymCount(int []symCount);
   public native int    GetSymbolInfo(int iSym, String []symName, int []symDim, int []dims, int []nNZ, String []explText);
   public native int    GetSymbolInfoByName(String symName, int []iSym, int []symDim, int []dims, int []nNZ, String []explText);
   public native int    GetIndexBase();
   public native int    SetIndexBase(int idxBase);
   public native int    DataReadStart(String symName, int []symDim, int []dims, int []nRecs, String []ErrMsg);
   public native int    DataRead(int []keys, double []val, int []changeIdx);
   public native int    DataReadDone();
   public native int    DataReadSparseColMajor(int idxBase, int []colPtr, int []rowIdx, double []vals);
   public native int    DataReadSparseRowMajor(int idxBase, int []rowPtr, int []colIdx, double []vals);
   public native int    DataReadDenseColMajor(double []vals);
   public native int    DataReadDenseRowMajor(double []vals);
   public native int    DataWriteStart(String symName, String explTxt, int symDim, int []dims, String []ErrMsg);
   public native int    DataWrite(int []keys, double val);
   public native int    DataWriteDone();
   public native int    DataWriteSparseColMajor(int []colPtr, int []rowIdx, double []vals);
   public native int    DataWriteSparseRowMajor(int []rowPtr, int []colIdx, double []vals);
   public native int    DataWriteDenseColMajor(int dataDim, double []vals);
   public native int    DataWriteDenseRowMajor(int dataDim, double []vals);
   public        long    GetidxPtr(){ return idxPtr;}
   public idx () { }
   public idx (long idxPtr) {
      this.idxPtr = idxPtr;
   }
   static
   {
      String stem = "idxjni";
      String bitsuffix = "";
      if ( System.getProperty("os.arch").toLowerCase().indexOf("64") >= 0 ||
           System.getProperty("os.arch").toLowerCase().indexOf("sparcv9") >= 0 ) {
           bitsuffix = "64";
      }
 
      try  {
 
          System.loadLibrary(stem + bitsuffix);
 
      } catch (UnsatisfiedLinkError e1) {
          // no java.library.path has been set
          // try again with java.class.path
          String libraryFullPath = null;
          String classPath = null;
          try {
               String packageName = (Class.forName(idx.class.getName()).getPackage().getName());
               StringBuilder sb = new StringBuilder();
               String[] bs = packageName.split("\\.");
               for (String s : bs) {
                  sb.append(s);
                  sb.append("/");
               }
               sb.append(idx.class.getSimpleName());
               sb.append(".class");
               ClassLoader cl = idx.class.getClassLoader();
 
               classPath = cl.getResource(sb.toString()).getPath();
               sb.insert(0, "/");
               classPath = classPath.substring(0, classPath.lastIndexOf(sb.toString()));
               if (classPath.endsWith("!")) {
                   int index = classPath.lastIndexOf("/");
                   if (index >= 0)
                      classPath = classPath.substring(0, index);
               }
               if (classPath.indexOf("/") >= 0) {
                   classPath = classPath.substring(classPath.indexOf(":")+1,classPath.length());
               }
 
               String prefix = "";
               String suffix = "";
 
               String os = System.getProperty("os.name").toLowerCase();
               if (os.indexOf("win") >=0) {
                   suffix = ".dll";
               } else if (os.indexOf("mac") >= 0) {
                          prefix = "lib";
                          suffix = ".dylib";
               } else {
                    prefix = "lib";
                    suffix = ".so";
               }
 
               libraryFullPath = classPath + "/" + prefix + stem + bitsuffix + suffix ;
               if (os.indexOf("win") >=0) {
                   java.io.File apath = new java.io.File(libraryFullPath);
                   libraryFullPath = java.net.URLDecoder.decode(apath.getAbsolutePath(), "UTF-8");
                }
 
           } catch (Exception e2) {
               e2.printStackTrace();
               e1.printStackTrace();
               throw (e1);
           } finally {
               if (libraryFullPath == null)  {
                   e1.printStackTrace();
                   throw (e1);
               }
           }
 
           try {
 
                System.load(libraryFullPath);
 
           } catch (UnsatisfiedLinkError e3) {
               e3.printStackTrace();
               throw (e3);
           }
      }
   }
}
