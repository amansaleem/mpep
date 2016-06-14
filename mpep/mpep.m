function  mpep()
global mpepFigure;
% Run mpep
setupPaths();
[s d] = matlabui.showHostsDialog();
% user canceled hosts dialog
if ~isempty(s)
    mpepFigure = matlabui.MainFigure(s,d);
end

