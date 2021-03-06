/*  Java code generated by apiwrapper for GAMS Version 24.7.4 */
package com.gams.api;

public class gmd {
   public static final int GMD_PARAM  = 0; /* gmdActionType */
   public static final int GMD_UPPER  = 1;
   public static final int GMD_LOWER  = 2;
   public static final int GMD_FIXED  = 3;
   public static final int GMD_PRIMAL = 4;
   public static final int GMD_DUAL   = 5;

   public static final int GMD_DEFAULT    = 0; /* gmdUpdateType */
   public static final int GMD_BASECASE   = 1;
   public static final int GMD_ACCUMULATE = 2;

   public static final int GMD_NRSYMBOLS = 0; /* gmdInfoX */
   public static final int GMD_NRUELS    = 1;

   public static final int GMD_NAME      = 0; /* gmdSymInfo */
   public static final int GMD_DIM       = 1;
   public static final int GMD_TYPE      = 2;
   public static final int GMD_NRRECORDS = 3;
   public static final int GMD_USERINFO  = 4;
   public static final int GMD_EXPLTEXT  = 5;

   private long gmdPtr = 0;
   public native static int    GetReady (String[] msg);
   public native static int    GetReadyD(String dirName, String[] msg);
   public native static int    GetReadyL(String libName, String[] msg);
   public native int    Create   (String[] msg);
   public native int    CreateD  (String dirName, String[] msg);
   public native int    CreateDD (String dirName, String[] msg);
   public native int    CreateL  (String libName, String[] msg);
   public native int    Free     ();
   public native boolean    InitFromGDX(String fileName);
   public native boolean    InitFromDict(long gmoPtr);
   public native boolean    InitFromDB(long gmdSrcPtr);
   public native boolean    RegisterGMO(long gmoPtr);
   public native boolean    CloseGDX(boolean loadRemain);
   public native boolean    AddSymbolX(String symName, int aDim, int stype, int userInfo, String explText, long []vDomPtrIn, String []keyStr, long []symPtr);
   public native long    AddSymbolXPy(String symName, int aDim, int stype, int userInfo, String explText, long []vDomPtrIn, String []keyStr, boolean []status);
   public native boolean    AddSymbol(String symName, int aDim, int stype, int userInfo, String explText, long []symPtr);
   public native long    AddSymbolPy(String symName, int aDim, int stype, int userInfo, String explText, boolean []status);
   public native boolean    FindSymbol(String symName, long []symPtr);
   public native long    FindSymbolPy(String symName, boolean []status);
   public native boolean    GetSymbolByIndex(int idx, long []symPtr);
   public native long    GetSymbolByIndexPy(int idx, boolean []status);
   public native boolean    ClearSymbol(long symPtr);
   public native boolean    CopySymbol(long tarSymPtr, long srcSymPtr);
   public native boolean    FindRecord(long symPtr, String []keyStr, long []symIterPtr);
   public native long    FindRecordPy(long symPtr, String []keyStr, boolean []status);
   public native boolean    FindFirstRecord(long symPtr, long []symIterPtr);
   public native long    FindFirstRecordPy(long symPtr, boolean []status);
   public native boolean    FindFirstRecordSlice(long symPtr, String []keyStr, long []symIterPtr);
   public native long    FindFirstRecordSlicePy(long symPtr, String []keyStr, boolean []status);
   public native boolean    FindLastRecord(long symPtr, long []symIterPtr);
   public native long    FindLastRecordPy(long symPtr, boolean []status);
   public native boolean    FindLastRecordSlice(long symPtr, String []keyStr, long []symIterPtr);
   public native long    FindLastRecordSlicePy(long symPtr, String []keyStr, boolean []status);
   public native boolean    RecordMoveNext(long symIterPtr);
   public native boolean    RecordHasNext(long symIterPtr);
   public native boolean    RecordMovePrev(long symIterPtr);
   public native boolean    SameRecord(long symIterPtrSrc, long symIterPtrtar);
   public native boolean    RecordHasPrev(long symIterPtr);
   public native boolean    GetElemText(long symIterPtr, String []txt);
   public native boolean    GetLevel(long symIterPtr, double []value);
   public native boolean    GetLower(long symIterPtr, double []value);
   public native boolean    GetUpper(long symIterPtr, double []value);
   public native boolean    GetMarginal(long symIterPtr, double []value);
   public native boolean    GetScale(long symIterPtr, double []value);
   public native boolean    SetElemText(long symIterPtr, String txt);
   public native boolean    SetLevel(long symIterPtr, double value);
   public native boolean    SetLower(long symIterPtr, double value);
   public native boolean    SetUpper(long symIterPtr, double value);
   public native boolean    SetMarginal(long symIterPtr, double value);
   public native boolean    SetScale(long symIterPtr, double value);
   public native boolean    SetUserInfo(long symPtr, int value);
   public native boolean    AddRecord(long symPtr, String []keyStr, long []symIterPtr);
   public native long    AddRecordPy(long symPtr, String []keyStr, boolean []status);
   public native boolean    DeleteRecord(long symIterPtr);
   public native boolean    GetKeys(long symIterPtr, int aDim, String []keyStr);
   public native boolean    GetKey(long symIterPtr, int idx, String []keyStr);
   public native boolean    GetDomain(long symPtr, int aDim, long []vDomPtrOut, String []keyStr);
   public native boolean    CopySymbolIterator(long symIterPtrSrc, long []symIterPtrtar);
   public native long    CopySymbolIteratorPy(long symIterPtrSrc, boolean []status);
   public static native boolean    FreeSymbolIterator(long symIterPtr);
   public native boolean    MergeUel(String uel, int []uelNr);
   public native boolean    Info(int infoKey, int []ival, double []dval, String []sval);
   public native boolean    SymbolInfo(long symPtr, int infoKey, int []ival, double []dval, String []sval);
   public native boolean    SymbolDim(long symPtr, int []aDim);
   public native boolean    SymbolType(long symPtr, int []stype);
   public native boolean    WriteGDX(String fileName, boolean noDomChk);
   public native boolean    SetSpecialValues(double []specVal);
   public native boolean    SetDebug(int debugLevel);
   public native boolean    GetLastError(String []msg);
   public native boolean    CheckDBDV(boolean []dv);
   public native boolean    CheckSymbolDV(long symPtr, boolean []dv);
   public native boolean    GetFirstDBDV(long []dvHandle);
   public native long    GetFirstDBDVPy(boolean []status);
   public native boolean    GetFirstDVInSymbol(long symPtr, long []dvHandle);
   public native long    GetFirstDVInSymbolPy(long symPtr, boolean []status);
   public native boolean    DomainCheckDone();
   public native boolean    GetFirstDVInNextSymbol(long dvHandle, boolean []nextavail);
   public native boolean    MoveNextDVInSymbol(long dvHandle, boolean []nextavail);
   public native boolean    FreeDVHandle(long dvHandle);
   public native boolean    GetDVSymbol(long dvHandle, long []symPtr);
   public native long    GetDVSymbolPy(long dvHandle, boolean []status);
   public native boolean    GetDVSymbolRecord(long dvHandle, long []symIterPtr);
   public native long    GetDVSymbolRecordPy(long dvHandle, boolean []status);
   public native boolean    GetDVIndicator(long dvHandle, int []viol);
   public native boolean    InitUpdate(long gmoPtr);
   public native boolean    UpdateModelSymbol(long gamsSymPtr, int actionType, long dataSymPtr, int updateType, int []noMatchCnt);
   public native boolean    CallSolver(String solvername);
   public native boolean    CallSolverTimed(String solvername, double []time);
   public native boolean    DenseSymbolToDenseArray(long cube, int []vDim, long symPtr, int field);
   public native boolean    SparseSymbolToDenseArray(long cube, int []vDim, long symPtr, long []vDomPtr, int field, int []nDropped);
   public native boolean    SparseSymbolToSqzdArray(long cube, int []vDim, long symPtr, long []vDomSqueezePtr, long []vDomPtr, int field, int []nDropped);
   public native boolean    DenseArrayToSymbol(long symPtr, long []vDomPtr, long cube, int []vDim);
   public native boolean    DenseArraySlicesToSymbol(long symPtr, long []vDomSlicePtr, long []vDomPtr, long cube, int []vDim);
   public        long    GetgmdPtr(){ return gmdPtr;}
   public gmd () { }
   public gmd (long gmdPtr) {
      this.gmdPtr = gmdPtr;
   }
   static
   {
      String stem = "gmdjni";
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
               String packageName = (Class.forName(gmd.class.getName()).getPackage().getName());
               StringBuilder sb = new StringBuilder();
               String[] bs = packageName.split("\\.");
               for (String s : bs) {
                  sb.append(s);
                  sb.append("/");
               }
               sb.append(gmd.class.getSimpleName());
               sb.append(".class");
               ClassLoader cl = gmd.class.getClassLoader();
 
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
