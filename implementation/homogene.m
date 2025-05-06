function centroids_3D = homogene(centroids)
    % On ajoute une troisième composante égale à zéro
    centroids_3D = [centroids, ones(size(centroids, 1), 1)];
end



