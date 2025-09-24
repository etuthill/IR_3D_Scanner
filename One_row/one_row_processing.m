% load csv into table
data = readtable('one_row_data.csv');
pan   = data.pan; 
IR    = data.irValue;

n_rows = 1; 

% build pan axis (grid) from step size
allPans = unique(pan);
d = diff(allPans);
panStep = round(median(abs(d(d>0))));
pangrid = allPans(1):panStep:allPans(end);
nCols   = length(pangrid);

% preallocate ir grid
IRgrid = nan(n_rows, nCols);

% fill ir grid row by row
% get pan + ir for this row
p = pan;
v = IR;

% sort by pan
[p, sidx] = sort(p, 'ascend');
v = v(sidx);

% interpolate onto full pan grid
rowVals = interp1(p, v, pangrid, 'linear', NaN);

% apply small shift on odd rows (servo lag)
k = 5;  
shifted = nan(1,nCols);
if k > 0
    shifted(1+k:end) = rowVals(1:end-k);
elseif k < 0
    shifted(1:end+k) = rowVals(1-k:end);
else
    shifted = rowVals;
end
rowVals = shifted;

% save into grid
IRgrid(1,:) = rowVals;

% plot ir heatmap
figure
imagesc(pangrid, 1, IRgrid);
set(gca,'YDir','normal')
xlabel('Pan (deg)'); ylabel('Row');
title('IR Heatmap');
colormap(hot)
h = colorbar; 
h.Label.String = 'IR Data';
xlim([27, 83])
ylim([0.5 1.5]); 
set(gca, 'YTick', 1) 
set(gca, 'YTickLabel', {'1'}) 