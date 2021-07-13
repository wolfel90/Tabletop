using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Die : MonoBehaviour {
    
    [Serializable]
    public struct AngleFacePair {
        public Quaternion upVector;
        public int face;
    }

    public AngleFacePair[] FaceValues;

    public int GetCurrentFaceValue() {
        int result = 0;
        if(FaceValues.Length > 0) {
            float largest = float.MinValue;
            float current;
            for(int i = 0; i < FaceValues.Length; ++i) {
                current = Quaternion.Dot(FaceValues[i].upVector.normalized, gameObject.transform.rotation);
                //current = Vector3.Dot(gameObject.transform.rotation.eulerAngles.normalized, Vector3.up);
                if (current > largest) {
                    result = FaceValues[i].face;
                    largest = current;
                    
                }
            }
        }
        return result;
    }
}
