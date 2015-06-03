function correlate_regions(region_matrix_01, region_matrix_02, ft_plan);
	
	# Number of regions
	num_regions = size(region_matrix_01, 3);
	
	# Loop over all the regions, calculating the SCC of each pair
	for k = 1 : num_regions
		scc(region_matrix_01[:, :, k], region_matrix_02[:, :, k], ft_plan);
	end
	
	
end