clc
clear all
close all

[scene,palette1]=imread('Diagramme.png');

[obj,palette2]=imread('phelma.png');
obj=imresize(obj,4);
[largeur, longueur]=size(obj)


% Now replace pixels in the scene with the object image
result = scene;
%   Define where you want to place the object image in the scene
rowshift = 200; % décalage depuis le haut
colshift = 300; % décalage depuis la gauche
%   Perform the actual indexing to replace the scene's pixels with the object
result((1:largeur)+rowshift, (1:longueur)+colshift) = obj;
%   Display the results


iresult = image(result);

axis off
