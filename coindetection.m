F = imread('concoin.jpg');
I = F;

F = rgb2gray(F);

%F = medfilt2(F);
F = imgaussfilt(F);
F = imgaussfilt(F);
F = imgaussfilt(F);

[row,col] = size(F);

G = F;

F = imbinarize(F);

W1 = strel('disk',11);
W2 = strel('disk',3);

F = imfill(F,'holes');

%figure;
%imshow(F);

F = imerode(F,W1);
F = imdilate(F,W2);

figure ; 
imshow(F);
L = bwlabel(F);
[row , col] = size(L) ; 
maxx = max(L(:));
ma = zeros(1,maxx+2);
for i = 1:row 
    for j = 1:col 
        if(L(i,j)>0)
            ma(L(i,j)) = ma(L(i,j))+1;
        end
    end
end

for i = 1:maxx
    coinorder(i).id = i; 
    coinorder(i).length = ma(i); 
end

T = struct2table(coinorder); 
sortedcoinorder  = sortrows(T, 'length');
mm = zeros(1,maxx) ; 

for i = 1:maxx 
    mm(sortedcoinorder.id(i)) = i;
    
    if(i>1)
        if(sortedcoinorder.length(i-1)==sortedcoinorder.length(i))
            mm(sortedcoinorder.id(i)) = mm(sortedcoinorder.id(i-1));
        else
            mm(sortedcoinorder.id(i)) = i; 
        end
    end
      
end

rank = zeros(row,col);
for i = 1:row 
    for j = 1:col 
        if(L(i,j)>0)
            rank(i,j) = mm(L(i,j));
            
        end
    end
end

figure;
imshow(I);
hold on;

st = regionprops(L,'BoundingBox');

for k = 1 : length(st)
  thisBB = st(k).BoundingBox;
  
  rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],'EdgeColor','r','LineWidth',2);
  
  width = thisBB(3);
  height = thisBB(4);
  
  xx = thisBB(2) + (width/2);
  yy = thisBB(1) + (height/2);
  
  text(thisBB(1),thisBB(2)-10,sprintf('Rank: %d',rank(uint32(xx),uint32(yy))),'Color','green','FontSize',11);
  
end
hold off;