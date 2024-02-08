using System;
using System.Linq;
using MathNet.Numerics;
using MathNet.Numerics.LinearAlgebra;
using MathNet.Numerics.LinearAlgebra.Double;

class Program
{
    // Quadratic regression
    static void Main(string[] args)
    {
        var x = new double[] { 1, 3, 5, 7 };
        var y = new double[] { 2, 4, 6, 8 };

        var n = x.Length;
        var sumX = x.Sum();
        var sumX2 = x.Select(x => x * x).Sum();
        var sumX3 = x.Select(x => x * x * x).Sum();
        var sumX4 = x.Select(x => x * x * x * x).Sum();
        var sumY = y.Sum();
        var sumXY = x.Zip(y, (x, y) => x * y).Sum();
        var sumX2Y = x.Zip(y, (x, y) => x * x * y).Sum();

        Console.WriteLine($"n = {n}");
        Console.WriteLine($"sumX = {sumX}");
        Console.WriteLine($"sumX2 = {sumX2}");
        Console.WriteLine($"sumX3 = {sumX3}");
        Console.WriteLine($"sumX4 = {sumX4}");
        Console.WriteLine($"sumY = {sumY}");
        Console.WriteLine($"sumXY = {sumXY}");
        Console.WriteLine($"sumX2Y = {sumX2Y}");

        var A = DenseMatrix.OfArray(new double[,]{
            { sumX4, sumX3, sumX2 },
            { sumX3, sumX2, sumX },
            { sumX2, sumX, n },
        });
        var B = DenseVector.OfArray(new double[] { sumX2Y, sumXY, sumY });
        var X = A.Solve(B);
        Console.WriteLine($"solution = {X}");
    }
}
