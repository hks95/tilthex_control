function uu = energy_func(in)
    energy = in.^2;
    uu = sum(energy(:));
end