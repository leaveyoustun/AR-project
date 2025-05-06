clear all
image = imread('IMG_0171.JPG');

pts_monde = [
        0, 0, 1;
        6.9, 0.1, 1;
        12.8, -2.2, 1;
        -1.6, 5.1, 1;
        4.8, 5.8, 1;
        12.2, 2.3, 1;
        0.25, 8.15, 1;
        10.8, 7.1, 1;
];

pts_image=[
    1198.5, 1474.5, 1;
    1938.5, 1542.5, 1;
    2586.5, 1826.5, 1;
    1194.5, 1066.5, 1;
    1818.5, 1074.5, 1;
    2530.5, 1402.5, 1;
    1442.5, 878.50, 1;
    2406.5, 1034.5, 1;
];


% On construit la matrice A pour le système d'équations linéaires
A = [];
for i = 1:size(pts_image, 1)
    X = pts_monde(i, :);
    x = pts_image(i, :);
    A = [A; zeros(1, 3), -X, x(2)*X; X, zeros(1, 3), -x(1)*X];
end

% On résout le système d'équations linéaires
[~, ~, V] = svd(A);
H = reshape(V(:, end), 3, 3)';

% On normalise la matrice homographie
H = H / H(3, 3);


disp('Matrice Homographie H:');
disp(H);
H_image=H*(pts_monde)';
H_image=H_image/1e+3;
disp('Pts image retrouvé par homographie');
disp(H_image);



figure(1)
imshow(image);

hold on;
for i=1:size(pts_monde)
    plot(H_image(1,i)/H_image(3,i), H_image(2,i)/H_image(3,i), 'r.', 'MarkerSize', 10)
end

hold off; 
title('Points sur l''image via H');

load('calibrationSessionPhtoto.mat')
K=calibrationSession.CameraParameters.K;
R1_prime=inv(K)*H(:,1);
R2_prime=inv(K)*H(:,2);
T_prime =inv(K)*H(:,3);

x=det([R1_prime,R2_prime,cross(R1_prime,R2_prime)]);
alpha=(1/x)^(1/4);

R1 = alpha*R1_prime;
R2 = alpha*R2_prime;
R3 = cross(R1,R2);
T= alpha*T_prime;

R=[R1 R2 R3];
P=K*[R T];

disp('Matrice projection P:');
disp(P);


pts_monde_3D = [
        0, 0, 0, 1;
        6.9, 0.1,0, 1;
        12.8, -2.2,0, 1;
        -1.6, 5.1,0, 1;
        4.8, 5.8,0, 1;
        12.2, 2.3,0, 1;
        0.25, 8.15,0 1;
        10.8, 7.1,0, 1;
];

P_image= P*pts_monde_3D';

for i=1:size(pts_monde_3D)
    P_image(:,i) = P_image(:,i)/P_image(3,i);
end

disp('Point image après matrice P')
disp(P_image)

figure(2)
imshow(image);
hold on; 

for i=1:size(pts_monde)
    plot(P_image(1,i)/P_image(3,i), P_image(2,i)/P_image(3,i), 'r.', 'MarkerSize', 10)
end

hold off;  
title('Points sur l''image via P');