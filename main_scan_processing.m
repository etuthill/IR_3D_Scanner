% load csv into table
data = readtable('regular_data.csv');
rowID = data.rowID; 
pan = data.pan; 
tilt = data.tilt; 
IR = data.irValue;

% figure out how many scan rows there are
unique_rows = unique(rowID); 
n_rows = length(unique_rows);

% build pan axis (grid) from step size
allPans = unique(pan);
d = diff(allPans);
panStep = round(median(abs(d(d>0))));
pangrid = allPans(1):panStep:allPans(end);
nCols   = length(pangrid);

% preallocate ir grid
IRgrid = nan(n_rows, nCols);

% fill ir grid row by row
for r = 1:n_rows
    % get pan + ir for this row
    idx = rowID == unique_rows(r);
    p = pan(idx);
    v = IR(idx);

    % sort by pan
    [p, sidx] = sort(p, 'ascend');
    v = v(sidx);

    % interpolate onto full pan grid
    rowVals = interp1(p, v, pangrid, 'linear', NaN);

    % apply small shift on odd rows (servo lag)
    k = 5;  
    if mod(unique_rows(r),2)==1
        shifted = nan(1,nCols);
        if k > 0
            shifted(1+k:end) = rowVals(1:end-k);
        elseif k < 0
            shifted(1:end+k) = rowVals(1-k:end);
        else
            shifted = rowVals;
        end
        rowVals = shifted;
    end

    % save into grid
    IRgrid(r,:) = rowVals;
end

% plot ir heatmap
figure
imagesc(pangrid, unique(tilt), IRgrid);
set(gca,'YDir','normal')
xlabel('Pan (deg)'); ylabel('Tilt (deg)');
title('IR Heatmap');
colormap(hot)
h = colorbar; 
h.Label.String = 'IR Data';
xlim([27, 83])

%%
% convert ir values to distance using fit eqn
DistGrid = nan(size(IRgrid));
DistGrid(valid) = (3985 ./ IRgrid(valid)).^(1/0.9182);

% plot distance heatmap
figure
imagesc(pangrid, unique(tilt), DistGrid);
set(gca,'YDir','normal')
xlabel('Pan (deg)'); ylabel('Tilt (deg)');
title('Distance Heatmap');
colormap(flipud(hot))
h = colorbar; 
h.Label.String = 'Distance (in)';
xlim([27, 83])
clim([5 40])
