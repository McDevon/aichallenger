#ifndef AI_CHAL_PONG_OBJECT_H
#define AI_CHAL_PONG_OBJECT_H

class PongObject {
    
public:
    
    /*
     *  Instance variables
     */
    
    // Position
    float x;
    float y;
    
    // Size
    float width;
    float height;
    
    // Hotspot (relative to size: 0.0 ... 1.0)
    float xHotspot;
    float yHotspot;
    
    // Movement
    float xSpeed;
    float ySpeed;
    
    
    /*
     *  Instance methods
     */
    
    PongObject();
    ~PongObject();
    
}

#endif
