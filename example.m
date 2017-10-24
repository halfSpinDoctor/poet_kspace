% SCRIPT example.m
%
% Example script: Plot POET simulations of TSE sequences with ETL=6
% and six different TE times to see how k-space is reordered
%
% Samuel A. Hurley
% University of Oxford
% 24 Oct 2017

% Plot each M0X/M0Y simulation pair from SampleData folder
plotKspaceTSE('SampleData/DspData_M0X_TE10.dsv', 'SampleData/DspData_M0Y_TE10.dsv', 'TSE_TE10ms', 6, 10);
plotKspaceTSE('SampleData/DspData_M0X_TE20.dsv', 'SampleData/DspData_M0Y_TE20.dsv', 'TSE_TE20ms', 6, 10);
plotKspaceTSE('SampleData/DspData_M0X_TE30.dsv', 'SampleData/DspData_M0Y_TE30.dsv', 'TSE_TE30ms', 6, 10);
plotKspaceTSE('SampleData/DspData_M0X_TE40.dsv', 'SampleData/DspData_M0Y_TE40.dsv', 'TSE_TE40ms', 6, 10);
plotKspaceTSE('SampleData/DspData_M0X_TE50.dsv', 'SampleData/DspData_M0Y_TE50.dsv', 'TSE_TE50ms', 6, 10);
plotKspaceTSE('SampleData/DspData_M0X_TE60.dsv', 'SampleData/DspData_M0Y_TE60.dsv', 'TSE_TE60ms', 6, 10);
