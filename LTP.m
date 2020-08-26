%% 0:up,1:down,2:up2
function [val]= LTP(img,i,j,threshold,m)
    val = 0;
    if m == 0
        if img(i-1,j-1)-img(i,j) >threshold
           val=val+4;
        end
        if img(i-1,j)-img(i,j) >threshold
           val=val+1;
        end
        if img(i-1,j+1)-img(i,j) >threshold
           val=val+8;
        end
        if img(i,j+1)-img(i,j) >threshold
           val=val+128;
        end
        if img(i+1,j+1)-img(i,j) >threshold
           val=val+32;
        end
        if img(i+1,j)-img(i,j) >threshold
           val=val+2;
        end
        if img(i+1,j-1)-img(i,j) >threshold
           val=val+16;
        end
        if img(i,j-1)-img(i,j) >threshold
           val=val+64;
        end  
    end
    if m == 1
        if img(i,j)-img(i-1,j-1) >threshold
           val=val+1;
        end
        if img(i,j)-img(i-1,j)>threshold
           val=val+2;
        end
        if img(i,j)-img(i-1,j+1)>threshold
           val=val+4;
        end
        if img(i,j)-img(i,j+1)>threshold
           val=val+8;
        end
        if img(i,j)-img(i+1,j+1)>threshold
           val=val+16;
        end
        if img(i,j)-img(i+1,j)>threshold
           val=val+32;
        end
        if img(i,j)-img(i+1,j-1)>threshold
           val=val+64;
        end
        if img(i,j)-img(i,j-1) >threshold
           val=val+128;
        end
    end
    if m == 2
        for col = j-2:j+1
            if img(i-2,col) - img(i,j)>threshold
                val=val+2^(col+2-j);   
            end
        end
        for row = i-2:i+1
            if img(row,j+2)-img(i,j) > threshold
                val=val+2^(row+6-i);
            end
        end
        for col = j+2:-1:j-1
            if img(i+2,col) - img(i,j) > threshold
                val=val+2^(j+10-col);
            end
        end
        for row = i+2:-1:i-1
            if img(row,j-2)-img(i,j) > threshold
                val=val+2^(i+14-row);
            end
        end     
    end
    
    if m == 3
        for col = j-2:j+1
            if img(i-2,col) - img(i,j)>threshold
                val=val+2^(col+2-j);   
            end
        end
        for row = i-2:i+1
            if img(row,j+2)-img(i,j) > threshold
                val=val+2^(row+6-i);
            end
        end
        for col = j+2:-1:j-1
            if img(i+2,col) - img(i,j) > threshold
                val=val+2^(j+10-col);
            end
        end
        for row = i+2:-1:i-1
            if img(row,j-2)-img(i,j) > threshold
                val=val+2^(i+14-row);
            end
        end     
    end
end


