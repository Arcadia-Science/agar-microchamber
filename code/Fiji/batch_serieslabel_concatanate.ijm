/*This Fiji macro prompts the user to select a directory and then creates a new directory within it. 
* It then opens each TIFF file in the selected directory, enhances contrast and adds custom  time labels to each image, 
* before saving the modified image with a label suffix in the new directory, and finally concatenates all open images.
*/

// Prompt user to select a directory
dir=getDirectory("Choose a Directory");

// Print the selected directory path to the console
print(dir);

// Create a new directory called "label" within the selected directory
splitDir=dir + "label";
print(splitDir);
File.makeDirectory(splitDir);

// Get a list of files in the selected directory
list = getFileList(dir);

// Loop through each file in the list
for (i=0; i<list.length; i++) {
     // If the file ends with ".tif"
     if (endsWith(list[i], ".tif")){

        // Print the file index and path to the console
        print(i + ": " + dir+list[i]);

        // Open the image file
        open(dir+list[i]);

        // Get the name of the image file
        imgName=getTitle();

        // Get the index of the ".tif" extension in the file name
        baseNameEnd=indexOf(imgName, ".tif");

        // Get the base name of the file (without the ".tif" extension)
        baseName=substring(imgName, 0, baseNameEnd);

        // Enhance the contrast of the image
        run("Enhance Contrast", "saturated=0.35");

        // Convert the image to RGB color format
        run("RGB Color");

        // Add a custom label to the image indicating the frame number in seconds
        run("Series Labeler", "stack_type=[time series or movie] label_format=[Custom Format] custom_suffix=s custom_format=[] label_unit=[Custom Suffix] decimal_places=1 startup=0.000000000 interval=0.050010000 every_n-th=1 first=0 last=99 location_presets=Custom x_=1500 y_=20");

        // Add a custom label to the image indicating the frame number in minutes
        run("Series Labeler", "stack_type=[time series or movie] label_format=[Custom Format] custom_suffix=m custom_format=[] label_unit=[Custom Suffix] decimal_places=0 startup=" + (i*3)%60 + " interval=0.000000001 every_n-th=1 first=0 last=99 location_presets=Custom x_=1250 y_=20");

        // Add a custom label to the image indicating the frame number in hours
        run("Series Labeler", "stack_type=[time series or movie] label_format=[Custom Format] custom_suffix=h custom_format=[] label_unit=[Custom Suffix] decimal_places=0 startup=" + i*3/60 + " interval=0.000000001 every_n-th=1 first=0 last=99 location_presets=Custom x_=11000 y_=20");

        // Save the modified image with a label suffix in the new directory
        saveAs("Tiff", splitDir + imgName + "label.tif");

        // Close the image file
        run("Close All");
     };
};

// Concatenate all open images
run("Concatenate...", "all_open open");
