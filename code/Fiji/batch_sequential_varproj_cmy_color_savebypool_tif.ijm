/*
 * The Fiji macro creates tracks of cells in movies and applies a random color to each track.
 * Opens image stacks, performs cumulative variance projections, applies a random color to the tracks (cyan, magenta, or yellow), and
 * saves frames by pool ID. First the Fiji macro scans a directory for TIFF files with a specified suffix, 
 * then opens each file as a Bio-Formats movie, applies image processing to generate standard deviation images 
 * for each frame of the input movie, and saves in separate subdirectories of the specified output directory.
 */

// Prompt user to select the input directory
#@ File (label = "Input directory", style = "directory") input

// Prompt user to select the output directory
#@ File (label = "Output directory", style = "directory") output

// Prompt user to specify the file suffix
#@ String (label = "File suffix", value = ".tif") suffix

// Get the start time of the macro
start = getTime();
print("start time: " + start);

// Call the processFolder function to scan the input directory and process TIFF files with the specified suffix
processFolder(input);

// Define a function to scan a folder to find files with correct suffix
function processFolder(input) {
	
	// Get a list of files in the input directory
	list = getFileList(input);
	
	// Sort the list of files alphabetically
	list = Array.sort(list);
	
	// Loop through each file in the list
	for (i = 0; i < list.length; i++) {
		print("i=" + i);
		// If the file ends with the specified suffix
		if(endsWith(list[i], suffix)) {
			print("file is " + list[i]);
			
			// Get the folder name (without the suffix) from the file name
			folderNameEnd = indexOf(list[i], ".tif");
			folderName = substring(list[i], 0, folderNameEnd);
			
			File.makeDirectory(output + File.separator + folderName);
			
			// Create a new folder for the output standard deviation images
			File.makeDirectory(output + File.separator + folderName + File.separator + "var");
			
			// Call the processFile function to open and process the current TIFF file
			processFile(input, output, list[i]);
		};
	};
};

// Define a function to process a single TIFF file
function processFile(input, output, file) {

	// Print the name of the current file to the console
	print("Processing: " + input + File.separator + file);
	
	// Open the TIFF file as a Bio-Formats movie
	run("Bio-Formats Importer", "open=" + input + File.separator + file + " color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	
	// Get the title of the current image stack
	imageTitle = getTitle();
	print(imageTitle);
	
	// Rename the current image stack to "stack"
	stack = getImageID();
	rename("stack");
	
	// Get the dimensions of the current image stack
	getDimensions(width, height, channels, slices, frames);
	
	// Get the base name of the current file (without the suffix)
	baseNameEnd = indexOf(imageTitle, ".tif");
	baseName = substring(imageTitle, 0, baseNameEnd);
	rename("stack");
	
	// Define random color values for the output images
	color = random;
	print(color);
	if (color < 0.33333) {
		print("1");
		chandelete = 1;
	};
	if ((color <= 0.667) & (color > 0.33333)) {
		print("2");
		chandelete = 2;
	};
	if ( color > 0.667) {
		print("3");
		chandelete = 3;
	};
	print(chandelete);
	print("slices=" + slices);
	print("frames=" + frames);
	
	
	// Loop through each frame of the current image stack (excluding the first file)
	for (f = 2; f <= 687; f++){
		print(f);
		// Select the current frame of the image stack
		selectWindow("stack");
		
		// Generates a Z - projection of the standard deviation across the image stack, and splits channels.
		run("Z Project...", "stop=" + f + " projection=[Standard Deviation]");
		run("RGB Color");
		run("Make Composite");
		run("Split Channels");
		
		
		// Set the color of the output image to the random color value by deleting one of three channels.
		selectWindow("C" + chandelete + "-STD_stack");
		run("Select All");
		run("Clear", "slice");
		run("Merge Channels...", "c1=C1-STD_stack c2=C2-STD_stack c3=C3-STD_stack create");

		// Save the output standard deviation image
		saveAs("Tiff", output + File.separator + baseName + File.separator + "var" + File.separator + baseName + "_std_f" + f + ".tif");
		rename("STD");
	
		// Close the output standard deviation image
		close("STD");
	};

	// Close all windows
	run("Close All");
};

// Get the end time of the macro
endtime = getTime();

// Print the end time to the console
print("End time: " + endtime);
