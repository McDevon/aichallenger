#ifndef AI_CHAL_PONG_GAME_H
#define AI_CHAL_PONG_GAME_H

// Pong game objects
#include "pongcontroller.h"
#include "pongobject.h"
#include "pongpaddle.h"

class PongGame {
    
    //PongController *control1;
    //PongController *control2;
    
    //PongVisualizer *visualizer;
    
    //std::vector<PongController*> controllers;
    
    // Balls and paddles
    std::vector<PongPaddle*> paddles;
    std::vector<PongObject*> balls;

public:

    PongGame();
    ~PongGame();
    
    // Init the game
    int init();
    
    // Time passing
    int tick(float dt);

};

#endif