using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ApplyGaussianBlurEffect : MonoBehaviour
{
    public Material material;

    
    public int radius = 5;

    public float stdDev = 1.0f;

    public const float sqrtTwoPi = 2.506628f;

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        RenderTexture temporaryRenderTarget = RenderTexture.GetTemporary(source.width, source.height, 0, source.format);

        material.SetInt("_radius", radius);
        material.SetFloatArray("_kernel", GetKernel(radius, stdDev));

        // Perform both passes in order.
        Graphics.Blit(source, temporaryRenderTarget, material, 0);   // First pass.
        Graphics.Blit(temporaryRenderTarget, destination, material, 1);	// Second pass.

        RenderTexture.ReleaseTemporary(temporaryRenderTarget);
    }

    float[] GetKernel(int radius, float stdDev)
    {
        float[] output = new float[radius];

        float counter = 0.0f;

        for (int i = 0; i < radius; i++)
        {
            float gaussian = Gaussian(i, stdDev);

            output[i] = gaussian;

            if (i == 0)
                counter += gaussian;
            else
                counter += 2 * gaussian;
        }

        for (int i = 0; i < output.Length; i++)
            output[i] *= 1 / counter;

        /*
        float test = 0.0f;

        for (int i = 0; i < output.Length; i++)
            test += output[i];

        print(test);
        */

        return output;
    }

    float Gaussian(int x, float stdDev)
    {
        return (1 / (stdDev * sqrtTwoPi)) * Mathf.Exp(-1 * (x*x)/(2* stdDev * stdDev));
    }

}
