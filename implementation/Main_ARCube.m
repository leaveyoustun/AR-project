% On charge la vidéo
videoFile = 'test_4couleur.mp4'; 
videoObj = VideoReader(videoFile);
load("matrice_P.mat")

%Commande pour récuperer la vidéo depuis matLAB
%{
outputVideoFile = 'video_sortie.avi'; % Nom du fichier de sortie
outputVideoObj = VideoWriter(outputVideoFile, 'Uncompressed AVI');
open(outputVideoObj);
%}

figure;

% On convertit la vidéo en un tableau d'images
while hasFrame(videoObj)
    % On lit la frame courante
    frame = readFrame(videoObj);
    
    % On affiche la frame dans la figure
    imshow(frame);
    
    % On convertit la frame en double
    frame = im2double(frame);

    % On convertit la frame en espace couleur LAB
    C = makecform('srgb2lab');
    imLAB = applycform(frame, C);

    % On extrait les canaux A et B de LAB
    imA = imLAB(:, :, 2);
    imB = imLAB(:, :, 3);

    % On definit les valeurs LAB des couleurs à détecter (bleu, rouge, vert, jaune)
    colorsToDetect = [
        % Bleu
        -20, 30;
        % Rouge
        50, 40;
        % Vert
        0, -50;
        % Jaune
        70, 20
    ];

    % On initialise un tableau pour stocker les centroids
    centroids = [];

    % On itere à travers chaque couleur
    for colorIndex = 1:size(colorsToDetect, 1)
        % On obtient les valeurs LAB pour la couleur actuelle
        targetColorLAB = colorsToDetect(colorIndex, :);

        % On calcule la distance euclidienne entre chaque pixel et la couleur cible
        distance = sqrt((imA - targetColorLAB(1)).^2 + (imB - targetColorLAB(2)).^2);

        % On définit un seuil pour créer un masque binaire
        threshold = 20; % Ajustez le seuil au besoin
        binaryMask = distance < threshold;

        % On utilise imfill et imopen pour améliorer et remplir le masque binaire
        binaryMask = imfill(binaryMask, 'holes');
        se = strel('disk', 5);
        binaryMask = imopen(binaryMask, se);

        % On trouve les composantes connectées dans le masque binaire
        [labeledImage, numRegions] = bwlabel(binaryMask);

        % On itere à travers chaque région détectée et trouver son centroid
        for i = 1:numRegions
            % On crée un masque binaire pour la région actuelle
            currentRegionMask = labeledImage == i;

            % On utilise regionprops pour calculer le centroid
            regionMeasurements = regionprops(currentRegionMask, 'Centroid');

            % On stocke le centroid dans le tableau
            if ~isempty(regionMeasurements)
                centroids = [centroids; regionMeasurements.Centroid, colorIndex];
            end
        end
    end
    % On convertit en coordonnées homogènes 3D
    centroids_image = homogene(centroids(:, 1:2));
    centroids_monde = pinv(P) * centroids_image';
    % On normalise les points 
    for i = 1:size(centroids_monde, 2)
        centroids_monde(:, i) = centroids_monde(:, i) / centroids_monde(4, i);
    end
    centroids_cube_monde = centroids_monde';

    % On ajoute quatre lignes à la matrice centroids_cube_monde
    h = 1;
    for i = 1:4
        newRows = repmat(centroids_cube_monde(i, :), 1, 1);
        newRows(:, 3) = newRows(:, 3) + h;
        centroids_cube_monde = [centroids_cube_monde; newRows];
    end

    centroids_cube_image = P*centroids_cube_monde';

    for i = 1:size(centroids_cube_image, 2)
         centroids_cube_image(:, i) = centroids_cube_image(:, i) / centroids_cube_image(3, i);
    end

    % On definit les cotes du cube
    cube_edges = [
        1, 2;  % Edge 1-2
        2, 3;  % Edge 2-3
        3, 4;  % Edge 3-4
        4, 1;  % Edge 4-1
        1, 5;  % Edge 1-5
        2, 6;  % Edge 2-6
        3, 7;  % Edge 3-7
        4, 8;  % Edge 4-8
        5, 6;  % Edge 5-6
        6, 7;  % Edge 6-7
        7, 8;  % Edge 7-8
        8, 5;  % Edge 8-5
    ];
    
    hold on;
    for i = 1:size(cube_edges, 1)
        % On s'assure que les indices ne dépassent pas la taille de centroids_2D_cube
        if max(cube_edges(i, :)) <= size(centroids_cube_image, 2)
            line(centroids_cube_image(1, cube_edges(i, :)), centroids_cube_image(2, cube_edges(i, :)), 'Color', 'g', 'LineWidth', 2);
        end
    end   
    hold off;
    drawnow;
    
    %writeVideo(outputVideoObj, getframe(gcf));  

end

%close(outputVideoObj);

