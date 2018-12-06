// "BatchProcessFolders"
//
// This macro batch processes all the files in a folder and any
// subfolders in that folder. In this example, it runs the Subtract 
// Background command of TIFF files. For other kinds of processing,
// edit the processFile() function at the end of this macro.

   requires("1.33s"); 
   dir = getDirectory("Choose Source Directory "); //Choose the directory with our RGB data
   setBatchMode(true);
   count = 0;
   countFiles(dir);
   n = 0;
   processFiles(dir);
   
   function countFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              countFiles(""+dir+list[i]);
          else
              count++;
      }
  }

   function processFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              processFiles(""+dir+list[i]);
          else {
             showProgress(n++, count);
             path = dir+list[i];
             processFile(path);
          }
      }
  }

	function getFormat() {
 	formats = newArray("TIFF", "8-bit TIFF", "JPEG", "GIF", "PNG",
 	"PGM", "BMP", "FITS", "Text Image", "ZIP", "Raw");
 	Dialog.create("Batch Convert");
 	Dialog.addChoice("Convert to: ", formats, "TIFF");
 	Dialog.show();
 	return Dialog.getChoice();
	}

  function processFile(path) {
       if (endsWith(path, "Scene1Interval01.tif")) {
           open(path);
           
           run("Image Sequence...", "open=[path] convert sort");

           ////////////////////////////////////////
           ////////USE BELOW TO MAKE ADJUSTMENTS///
           ////////////////////////////////////////
           //run("Enhance Contrast", "saturated=0.35");
		   //run("Apply LUT", "stack");
		   //run("Subtract Background...", "rolling=15 create");
		   
           saveAs("Tiff", path + "BWStack");

           close();
      }
  }