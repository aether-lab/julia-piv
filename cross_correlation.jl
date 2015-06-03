function scc(IMAGE_01, IMAGE_02, PLAN)

   # Fourier transform of the first image
   ft_01 = PLAN(IMAGE_01);

   # Fourier transform of the second image
   ft_02 = PLAN(IMAGE_02);

   # Perform the cross correlation between the two images by
   # conjugate-multiplying their Fourier transforms.
   return spectral_corr_complex = ft_01 .* conj(ft_02);

end
