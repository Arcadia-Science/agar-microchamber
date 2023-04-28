/*The Fiji macro allows users to define square regions of interest (ROIs) in each image, 
 * duplicates the selected ROIs as stacks, and saves them as TIFF files in the output directory.
 * The macroprocesses image files with a specific suffix in a given input directory. 
 */

// Declare input and output directories and file suffix variables
#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = "good.tif") suffix

// Start a timer to measure script execution time
start = getTime();

// Open the ROI Manager and set measurement options
run("ROI Manager...");
run("Set Measurements...", "area mean modal min integrated redirect=None decimal=3");

// Define function to scan a folder// Open the ROI Manager and set measurement options to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(endsWith(list[i], suffix))
			roi_interactive_func(input, output, list[i]);
	};
};

/* Define a function that will open an image, make a square, and allow the useer to define square regions of 
 * interest. After the user is finished, the function will duplicate the regions as stacks
 * and then save them as tif files. 
 */

function roi_interactive_func(input, output, file) {
	print("Processing: " + input + File.separator + file);
	run("Bio-Formats Importer", "open=" + input + File.separator + file + " color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	imgName = getTitle();
	print(imgName);
	
	 // Extract base file name (without file extension) and species group name
	baseNameEnd=indexOf(imgName, suffix);
	baseName=substring(imgName, 0, baseNameEnd);
	groupbegin=indexOf(imgName, "_w");
	group= substring(imgName, 0, 2);
	
	// Open the ROI Manager and create a 300x300 pixel square ROI
    run("ROI Manager...");
	makeRectangle(0, 0, 300, 300);
	waitForUser("Select ROIs");
	
	// Process each user-defined ROI
	n = roiManager("count");
	for (x = 0; x < n; x++) {
		selectImage(imgName);
   		roiManager("select", x);
   		
   		// Duplicate each ROI as a new image stack
   		run("Duplicate...", "duplicate");
   		roi_name = baseName + "_" + x;
   		print(roi_name);
   		rename(roi_name);
   		selectImage(roi_name);
   		saveAs("Tiff", output + File.separator + roi_name + ".tif");
   		close(roi_name);
	};
	
	// Close all open images and clear the ROI Manager
	run("Close All");
	roiManager("deselect");
	roiManager("Delete");
};	

// Start processing the input folder
processFolder(input);