# Include meshgrid, etc
include("meshgrid.jl")

function gaussianWindowFilter(IMAGE_SIZE, STANDARD_DEVIATION)

	# Height if the images in pixels
	image_height = IMAGE_SIZE[1];
	
	# Width of the images in pixels
	image_width = IMAGE_SIZE[2];
	
	# Standard deviations in each direction
	std_x = STANDARD_DEVIATION[2];
	std_y = STANDARD_DEVIATION[1];
	
	# Centroid of the image
	xc = image_width  / 2;
	yc = image_height / 2;
	
	# Create X and Y coordinates
	(x, y) = meshgrid([1 : image_width], [1 : image_height]);
	
	# Calculate the Gaussian
	gaussian_window = exp(-(x - xc).^2 / (2 * std_x^2)) .* 
					exp(-(y - yc).^2 / (2 * std_y^2));
	
	# Return variables
	return gaussian_window
	
end