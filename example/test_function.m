% This function is meant to show you how PSPicker works taken some example SDS and nordic file
% as input
% 
% Usage: run test_function() in Command window

function test_function()

clear all
close all

%%% Parameters

function_path='../Functions/';
mainfile='mainfile.txt';

%%% Load Path

addpath(genpath(function_path));

%%%% Read events
% EVENTS=nor2event(PickerParam.input_nordic);
% EVENT=EVENTS(5);
% save('EVENT.mat','EVENT')

%%% Load one single event

EVENT=load('EVENT.mat');
EVENT=EVENT.EVENT;

%%% Assign 2 weight for all Sphases

[~,ind_S]=get_PHASE(EVENT.PHASES,'type','S');
            [EVENT.PHASES(ind_S).WEIGHT]=deal(2);

%%%% Start Refinment process

S=refine_PICKS(EVENT,mainfile,1);

end
