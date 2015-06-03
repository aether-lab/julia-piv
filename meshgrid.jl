
# This function creates a 2-D mesh-grid
# in a format consistent with Matlab's function meshgrid() 
function meshgrid(XV, YV)
	
	# Number of columns ("width")
	num_cols = length(XV);
	
	# Number of rows ("height")
	num_rows = length(YV);
	
	# Replace the columns vector
	X = repmat(XV', num_rows, 1);
	
	# Replate the rows vector
	Y = repmat(YV, 1, num_cols);
	
	# Return X and Y
	return X, Y
	
end