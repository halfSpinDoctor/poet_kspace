function [] = plotKspaceTSE(M0x_dsv, M0y_dsv, plotName, etl, esp, dummy_ro)
% function [] = plotKspaceTSE(M0x_dsv, M0y_dsv, plotName, etl, esp, dummy_ro)
%
% Function to read the DSV output of a Siemens MRI POET simulation
% gradient 0th moment (gradient area) for the turbo spin echo (TSE)
% sequence, and plot the kx-ky kspace sampling pattern.
%
% ASSUMES kx is the phase encoding direction, and ky is readout
%
% Inputs:
%    M0x_dsv  - POET output of DspData_M0X.dsv (0th moment of X-gradient)
%
%    M0y_dsv  - POET output of DspData_M0X.dsv (0th moment of Y-gradient)
%
%    plotName - the prefix of the output plots (no extension)
%
%    etl      - echo train length (a.k.a. turbo factor)
%
%    esp      - echo spacing [ms]
%
%    dummy_ro - number of dummy readouts. Default is ETL
%
% Outputs:
%    A plot of the kx phase encodes along echo train ([plotName]_
%
%
% Samuel A. Hurley
% University of Oxford - FMRIB
% v1.0 24 Oct 2017
%
% Revision History
%   v1.0 - Initial version, based on plotKspaceTE.m

% Parse input parameters

if ~exist('M0x_dsv', 'var') || ~exist('M0y_dsv', 'var')
  error('Must input DspData_M0X.dsv and DspData_M0X.dsv POET output')
end

if ~exist('etl', 'var') || isempty(etl)
  error('Must specify turbo factor (echo train length, ETL)');
else
  ETL = etl;
end

if ~exist('esp', 'var') || isempty(esp)
  ESP = 0;
  warning('Echo spacing (ESP) not specified. Plot labels will show echo number only');
else
  ESP = esp;
end

if ~exist('dummy_ro', 'var') || isempty(dummy_ro)
  DUMMY_RO = ETL;
  disp('DUMMY_RO: Assuming ETL dummy acquisitions');
else
  DUMMY_RO = dummy_ro;
end

% Load kx-ky data (M0x and M0y)
fprintf('Loading...kx DSV...');
kx_dsv = Read_dsv(M0x_dsv);
fprintf('ky DSV...');
ky_dsv = Read_dsv(M0y_dsv);
fprintf('done.\n');

kx = kx_dsv.timecourse;
ky = ky_dsv.timecourse;

% Split up kx by echo times:
% Vector to hold split readout sections by TE time
kx_te = zeros([ETL, size(kx,2)]);

% Find start index of each readout (use ky - RO grad)
ro_start_idx = find(diff(diff(ky)) < -100);

% % Debug RO start index
% plot(kx)
% hold on
% plot(ro_start_idx, kx(ro_stt_idx), 'og');

% Throw away dummy readouts
ro_start_idx(1:DUMMY_RO) = [];

% Assign kx to different TE vectors
for ii = 1:(length(ro_start_idx))
  te = mod(ii-1,ETL+1);
  
  if te > 0
    start_idx = ro_start_idx(ii);
    
    if ii < length(ro_start_idx)
      end_idx   = ro_start_idx(ii+1);
      kx_te(te, start_idx:end_idx) = kx(start_idx:end_idx);
    else
      % Final portion of PE vector
      kx_te(te, start_idx:end) = kx(start_idx:end);
    end
  end
end

% Plot Echo Train by TE
figure('units','normalized','outerposition',[0 0 1 1]); % Fullscreen
hold on;
plot(kx_te(1,:), 'y');
plot(kx_te(2,:), 'm');
plot(kx_te(3,:), 'c');

plot(kx_te(4,:), 'r');
plot(kx_te(5,:), 'g');
plot(kx_te(6,:), 'b');

title(['TSE Echo Train vs Phase Encode Ordering']);
legend_text = cell(0);
for ii = 1:ETL
  legend_text{ii} = ['Echo #' num2str(ii) ' (' num2str(ii*ESP) ' ms)'];
end
legend(legend_text);
savefig([plotName '_echoTrain.png']);

% Plot k-space by TE
figure;
hold on;
plot(kx_te(1,:), ky(:), 'y');
plot(kx_te(2,:), ky(:), 'm');
plot(kx_te(3,:), ky(:), 'c');

plot(kx_te(4,:), ky(:), 'r');
plot(kx_te(5,:), ky(:), 'g');
plot(kx_te(6,:), ky(:), 'b');

title('TSE Kspace Sampling Pattern');
legend(legend_text);
savefig([plotName '_kSpace.png']);

% DONE