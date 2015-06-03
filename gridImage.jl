# This function creates arrays X and Y that specify the column and row positions
# of grid points in images. 
#
function gridImage(IMAGE_SIZE, GRID_SPACING, GRID_BUFFER_Y, GRID_BUFFER_X)
	
	# Height if the images in pixels
	image_height = IMAGE_SIZE[1];
	
	# Width of the images in pixels
	image_width = IMAGE_SIZE[2];
	
	# Determine the vertical and horizontal grid spacing  in pixels.
	grid_spacing_y = GRID_SPACING[1];
	grid_spacing_x = GRID_SPACING[2];

	# Determine the left and right-side grid buffers in pixels.
	grid_buffer_x_left  = GRID_BUFFER_X[1];
	grid_buffer_x_right = GRID_BUFFER_X[2];

	# Determine the top and bottom edge grid buffers in pixels.
	grid_buffer_y_top    = GRID_BUFFER_Y[1];
	grid_buffer_y_bottom = GRID_BUFFER_Y[2];
	
	# Create the grid buffer array
	grid_buffer = 
	[
		grid_buffer_y_top,
		grid_buffer_x_left,
		image_height - grid_buffer_y_bottom + 1,
		image_width - grid_buffer_x_right + 1
	];
	
	# Print the grid buffer
	# println("Grid buffer = $grid_buffer");
	
	# Populate the grid
	if maximum(GRID_SPACING) == 0
		y = [1 : image_height]';
		x = [1 : image_width];
	else
		
		# Create a column vector specifying the vertical
		# coordinates of the Cartesian grid, for the case that
		# the grid point lies on the image border
		if grid_buffer[1] == 0
			y = int64([
				ceil((image_height - (floor(image_height/grid_spacing_y) - 2 ) *
				grid_spacing_y) / 2) : grid_spacing_y : (image_height - grid_spacing_y)
			]);
			
		else
			
			# Create a column vector specifying the vertical
			# coordinates of the Cartesian grid, using the 
			# originally input values for the grid buffer.
			y = [grid_buffer[1] : grid_spacing_y : grid_buffer[3]]
			
		end
		
		if grid_buffer[2] == 0
			
			# Create a row vector specifying the horizontal
			# coordinates of the Cartesian grid, for the case that 
			# the grid point lies on the image border.
			x = int64([
				ceil((image_width - (floor(image_width / grid_spacing_x) - 2) * 
				grid_spacing_x) / 2) : grid_spacing_x : (image_width - grid_spacing_x)
			]');
			
		else
			
			# Create a row vector specifying the horizontal
			# coordinates of the Cartesian grid, using the 
			# originally input values for the grid buffer.
			x = [grid_buffer[2] : grid_spacing_x : grid_buffer[4]]';
			
		end
		
	end
	
	# Vector to matrix conversion
	X = repmat(x, length(y), 1);
	Y = repmat(y, 1, length(x));
	
	# Return variables
	return Y, X
	
end




