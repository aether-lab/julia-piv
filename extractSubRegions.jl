function extractSubRegions(IMAGE, REGION_SIZE, GRID_POINTS_Y, GRID_POINTS_X)
	
	# This function has a bug in it where grid points
	# near the image border will not extract a full-size region,
	# and then the function crashes when this smaller sized array
	# is attempted to be assigned to an element of the full region matrix
	
	# Read the region size
	region_height = REGION_SIZE[1];
	region_width  = REGION_SIZE[2];
	
	# Read the image size
	(image_height, image_width) = size(IMAGE);
	
	# Read the grid points
	gy = GRID_POINTS_Y[:];
	gx = GRID_POINTS_X[:];
	
	# Count the number of regions
	num_regions = length(gy);
	
	# Leftmost and rightmost columns of the interrogation regions
	xMin = gx - ceil(region_width / 2) + 1;
	xMax = gx + floor(region_width / 2);
	
	# Top and bottom-most rows
	yMin = gy - ceil(region_height / 2) + 1;
	yMax = gy + floor(region_height / 2);
	
	# Allocate the region matrix
	region_matrix = zeros(Float64, (region_height, region_width, num_regions));
	
	# Extract all the regions.
	for k = 1 : num_regions
		region_matrix[:, :, k] = float(IMAGE[maximum([1, yMin[k]]) : minimum([image_height, yMax[k]]), 
		maximum([1, xMin[k]]) : minimum([image_width, xMax[k]])]);
	end
	
	# Return the grid
	return float32(region_matrix);
	
end