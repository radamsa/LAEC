using System;
using QUT.Gppg;

namespace LAEC
{
    public class LexLocation : IMerge<LexLocation>, IComparable
    {
        public static LexLocation Unknown = new LexLocation
        {
            m_tokLin = -1,
            m_tokCol = -1,
            m_tokELin = -1,
            m_tokECol = -1,
            m_tokPos = -1,
            m_tokEPos = -1
        };

        public static implicit operator int (LexLocation a)
        {
            return a.m_tokPos;
        }

        private int m_tokLin;
        private int m_tokCol;
        private int m_tokELin;
        private int m_tokECol;
        private int m_tokPos;
        private int m_tokEPos;

        public int StartLine { get { return m_tokLin; } }
        public int StartColumn { get { return m_tokCol; } }
        public int EndLine { get { return m_tokELin; } }
        public int EndColumn { get { return m_tokECol; } }
        public int StartPosition { get { return m_tokPos; } }
        public int EndPosition { get { return m_tokEPos; } }

        public LexLocation()
        {
        }

        public LexLocation(int tokLin, int tokCol, int tokELin, int tokECol, int tokPos, int tokEPos)
        {
            m_tokLin = tokLin;
            m_tokCol = tokCol;
            m_tokELin = tokELin;
            m_tokECol = tokECol;
            m_tokPos = tokPos;
            m_tokEPos = tokEPos;
        }

        public LexLocation Merge(LexLocation last)
        {
            return new LexLocation(this.StartLine, this.StartColumn, last.EndLine, last.EndColumn, this.StartPosition, last.EndPosition);
        }

        #region Overrides of Object

        /// <summary>
        /// Returns a string that represents the current object.
        /// </summary>
        /// <returns>
        /// A string that represents the current object.
        /// </returns>
        public override string ToString()
        {
            return m_tokPos < 0 ? "Unknown" : string.Format("line {0}, col {1} (pos {2}).", m_tokLin, m_tokCol, m_tokPos);
        }

        /// <summary>
        /// Compares the current instance with another object of the same type and returns an integer that indicates whether the current instance precedes, follows, or occurs in the same position in the sort order as the other object.
        /// </summary>
        /// <returns>
        /// A value that indicates the relative order of the objects being compared. The return value has these meanings: Value Meaning Less than zero This instance precedes <paramref name="obj"/> in the sort order. Zero This instance occurs in the same position in the sort order as <paramref name="obj"/>. Greater than zero This instance follows <paramref name="obj"/> in the sort order. 
        /// </returns>
        /// <param name="obj">An object to compare with this instance. </param><exception cref="T:System.ArgumentException"><paramref name="obj"/> is not the same type as this instance. </exception>
        public int CompareTo(object obj)
        {
            var other = obj as LexLocation;
            if (ReferenceEquals(other, null))
                return -1;
            if (ReferenceEquals(this, obj))
                return 0;

            return m_tokPos.CompareTo(other.m_tokPos);
        }

        #endregion
    }
}
