using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OrbitCam : MonoBehaviour {
    public Transform target;
    public float distance = 5.0f;
    public float xRotSpeed = 90.0f;
    public float yRotSpeed = 90.0f;
    public float panSpeed = 0.5f;

    public float yMinLimit = -20f;
    public float yMaxLimit = 80f;

    public float distanceMin = 0.5f;
    public float distanceMax = 15;

    private float rotX = 0f;
    private float rotY = 0f;
    
    private bool pan = false;
    
    void Start() {
        Vector3 angles = transform.eulerAngles;
        rotX = angles.y;
        rotY = angles.x;
    }
    
    void LateUpdate() {
        if(target) {
            if(Input.GetMouseButtonDown(2)) {
                pan = true;
            }
            if(Input.GetMouseButtonUp(2)) {
                pan = false;
            }

            if(pan) {
                target.transform.Translate(
                    new Vector3(
                        panSpeed * ((-Input.GetAxis("Mouse Y") * Mathf.Sin(Mathf.Deg2Rad * rotX)) - (Input.GetAxis("Mouse X") * Mathf.Cos(Mathf.Deg2Rad * rotX))),
                        0,
                        panSpeed * ((-Input.GetAxis("Mouse Y") * Mathf.Cos(Mathf.Deg2Rad * rotX)) + (Input.GetAxis("Mouse X") * Mathf.Sin(Mathf.Deg2Rad * rotX)))
                    ), Space.World
                );
            }

            if(Input.GetAxis("Horizontal") != 0 || Input.GetAxis("Vertical") != 0) {
                target.transform.Translate(
                    new Vector3(
                        panSpeed * (Input.GetAxisRaw("Horizontal") * Mathf.Cos(Mathf.Deg2Rad * rotX) + Input.GetAxisRaw("Vertical") * Mathf.Sin(Mathf.Deg2Rad * rotX)), 
                        0, 
                        panSpeed * (-Input.GetAxisRaw("Horizontal") * Mathf.Sin(Mathf.Deg2Rad * rotX) + Input.GetAxisRaw("Vertical") * Mathf.Cos(Mathf.Deg2Rad * rotX))
                    )
                );
            }

            if(Input.GetMouseButton(1)) {
                rotX += Input.GetAxis("Mouse X") * xRotSpeed * distance * 0.02f;
                rotY -= Input.GetAxis("Mouse Y") * yRotSpeed * 0.02f;
            }
            
            rotY = ClampAngle(rotY, yMinLimit, yMaxLimit);

            Quaternion rotation = Quaternion.Euler(rotY, rotX, 0);

            distance = Mathf.Clamp(distance - Input.GetAxis("Mouse ScrollWheel") * 5, distanceMin, distanceMax);

            RaycastHit hit;
            if(Physics.Linecast(target.position, transform.position, out hit)) {
                //distance -= hit.distance;
            }

            Vector3 negDistance = new Vector3(0.0f, 0.0f, -distance);
            Vector3 position = rotation * negDistance + target.position;

            transform.rotation = rotation;
            transform.position = position;
        }
    }

    public static float ClampAngle(float angle, float min, float max) {
        if (angle < -360f) angle += 360f;
        if (angle > 360f) angle -= 360f;

        return Mathf.Clamp(angle, min, max);
    }
}
