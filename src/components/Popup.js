import React,{useEffect,useState} from 'react'
import './Popup.css'

function Popup({isOpen,setIsOpen,repairs}) {
   const [repair,setRepair] = useState([]);
   useEffect(()=>{
    setRepair(repairs);
   },[]) 

  return (
    isOpen ? (
    <div className="popup">
         <div className="popup-inner">
            {repair.map((r,index)=>{
                return <><div key={index}>{r}</div><hr/></>
            })}
            <div className="close-btn" onClick={()=>{
                setIsOpen(false);
            }}>Close</div>
         </div>
    </div>
  ):""
  )
}

export default Popup