/*The Fiji macro sums multiple cell motility tracks.
 * The macro processes TIFF images in the specified input directory by sequentially opening, 
 * splitting channels, summing intensity values across images, merging channels, 
 * and converting to RGB color. The resulting images are saved as TIFF files in the output directory.
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

// Define a function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	
	// Get a list of files in the input directory
	list = getFileList(input);
	
	// Sort the list of files alphabetically
	list = Array.sort(list);
	
	// Remove file extensions from the file list
	for (i = 0; i < list.length; i++) {
		ind = lengthOf(list[i]);
		trunc = substring(list[i], 0, ind - 1);
		list[i] = trunc;
	};
	
	// Loop through each frame number in the range of 2 to 1200
	for (frame_num = 2; frame_num < 1200; frame_num++) {
		// Open the first TIFF file for the current frame number and split its channels
		run("Bio-Formats Importer", "open=" + input + File.separator + list[0] + File.separator + "var" + File.separator + list[0] + "_std_f" + frame_num + ".tif" +  " color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		rename("first");
		run("Split Channels");
		
		// Loop through each file in the list (excluding the first file)
		for (x = 1; x < list.length; x++) {
			print("i=" + i);
			// Open the current TIFF file for the current frame number and split its channels
			run("Bio-Formats Importer", "open=" + input + File.separator + list[x] + File.separator + "var" + File.separator + list[x] + "_std_f" + frame_num + ".tif" +  " color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
			rename("second");
			run("Split Channels");
			
				// Loop through the three color channels (red, green, and blue)
				for (c = 1; c < 4; c++) {
					
					// Add the corresponding channel of the current image to the previous image and store the result in a new 32-bit stack
					imageCalculator("Add create 32-bit stack", "C" + c + "-first","C" + c + "-second");
					getStatistics(area, mean, min, max, std, histogram);
					
					// Rename the new stack and close the original channel of the previous image
					rename("C" + c + "-hold");
					close("C" + c + "-first");
					
					// Make the new stack the active window and rename it to the original channel name
					selectWindow("C" + c + "-hold");
					rename("C" + c + "-first");
					close("C" + c + "-second");
				};
		};
		
		// Merge the three color channels back into a single image and convert it to an RGB color image
		run("Merge Channels...", "c1=C1-first c2=C2-first c3=C3-first create");
		run("RGB Color");
		
		// Save the output integrated color image
		saveAs("Tiff", output + File.separator + "sum_var" + File.separator + "sum_var_f" + frame_num + ".tif");	
		
		// Close all open images
		run("Close All");
	};
};
		
// Get the end time of the macro
endtime = getTime();

// Print the end time to the console
print("End time: " + endtime);
