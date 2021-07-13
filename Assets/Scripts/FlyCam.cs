using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FlyCam : MonoBehaviour {
    float mainSpeed = 20.0F; //regular speed
    float shiftAdd = 150.0F; //multiplied by how long shift is held
    float maxShift = 500.0F; //Maximum speed when holding shift
    float camSens = 0.25F; //How sensitive it with mouse
    private Vector3 lastMouse = new Vector3(255, 255, 255); //kind of in the middle of the screen, rather than at the top (play)
    private float totalRun = 1.0F;
 
    void Update() {
        if(Input.GetMouseButton(1)) {
            lastMouse = Input.mousePosition - lastMouse;
            lastMouse = new Vector3(-lastMouse.y * camSens, lastMouse.x * camSens, 0);
            lastMouse = new Vector3(transform.eulerAngles.x + lastMouse.x, transform.eulerAngles.y + lastMouse.y, 0);
            transform.eulerAngles = lastMouse;
            lastMouse = Input.mousePosition;
        } else {
            lastMouse = Input.mousePosition;
        }
        
        var p = GetBaseInput();
        if (Input.GetKey(KeyCode.LeftShift)) {
            totalRun += Time.deltaTime;
            p = p * totalRun * shiftAdd;
            p.x = Mathf.Clamp(p.x, -maxShift, maxShift);
            p.y = Mathf.Clamp(p.y, -maxShift, maxShift);
            p.z = Mathf.Clamp(p.z, -maxShift, maxShift);
        } else {
            totalRun = Mathf.Clamp(totalRun * 0.5F, 1, 1000);
            p = p * mainSpeed;
        }

        p = p * Time.deltaTime;
        transform.Translate(p);

        if(Input.GetKey(KeyCode.Space)) {
            transform.Translate(new Vector3(0, mainSpeed * Time.deltaTime, 0), Space.World);
        } else if(Input.GetKey(KeyCode.X)) {
            transform.Translate(new Vector3(0, -mainSpeed * Time.deltaTime, 0), Space.World);
        }
    }

    private Vector3 GetBaseInput() { 
        Vector3 p_Velocity = new Vector3();
        if (Input.GetKey (KeyCode.W)){
            p_Velocity += new Vector3(0, 0 , 1);
    }
        if (Input.GetKey (KeyCode.S)){
            p_Velocity += new Vector3(0, 0 , -1);
        }
        if (Input.GetKey (KeyCode.A)){
            p_Velocity += new Vector3(-1, 0 , 0);
        }
        if (Input.GetKey (KeyCode.D)){
            p_Velocity += new Vector3(1, 0 , 0);
        }
        if(Input.GetKey(KeyCode.Space)) {
            //p_Velocity += new Vector3(0, 1, 0);
        }
        if (Input.GetKey(KeyCode.X)) {
            //p_Velocity += new Vector3(0, -1, 0);
        }
        return p_Velocity;
    }
}
