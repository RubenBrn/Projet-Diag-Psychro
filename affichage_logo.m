clc
clear all
close all

[scene,palette1]=imread('Diagramme.png');
if ~isempty(palette1)
    Im = ind2rgb(scene,palette1);
end
[obj,palette2]=imread('logo.jpg');
if ~isempty(palette2)
    Im = ind2rgb(obj,palette2);
end
obj=imresize(obj,0.5);

[largeur, longueur]=size(obj)


% Now replace pixels in the scene with the object image
result = scene;
%   Define where you want to place the object image in the scene
rowshift = 0; % d??calage depuis le haut
colshift = 0; % d??calage depuis la gauche
%   Perform the actual indexing to replace the scene's pixels with the object
imax=largeur;
jmax=longueur;
for i=1:imax
    for j=1:jmax
        
        result(i,j) = obj(i,j);
    end 
end 
%   Display the results


iresult = image(result);

axis off
