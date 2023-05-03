use majors

db.majors.insert(
    {
        _id: 'CS', 
        description: 'Computer Science'
    }
)

db.majors.insert(
    {
        _id: 'BIOL', 
        description: 'Biology'
    }
)

db.majors.insert(
    {
        _id: 'POSC', 
        description: 'Political Science'
    }
)

db.students.insert( 
    {
        _id: 1, 
        name: 'Stephanie Schultz', 
        majors: ['CS']
    }    
)

db.students.insert( 
    {
        _id: 2, 
        name: 'Phillip Thomas', 
        majors: ['BIOL']
    }    
)

db.students.insert( 
    {
        _id: 3, 
        name: 'Christopher Smith', 
        majors: ['BIOL']
    }    
)

db.students.insert( 
    {
        _id: 4, 
        name: 'Megan Marshall', 
        majors: ['POSC', 'CS']
    }    
)

db.students.insert( 
    {
        _id: 5, 
        name: 'Michael Morales Jr.', 
        majors: ['POSC']
    }    
)

db.students.insert( 
    {
        _id: 6, 
        name: 'Thyago Mota', 
        majors: ['MATH']
    }    
)

// Stage 1: “unwind” majors
// The majors field in students is an array. You need to "unwind" this array in order to produce documents with single-value majors.

db.students.aggregate(
    [
        {
            $unwind: "$majors"
        }
    ]
)

// Stage 2: use $lookup
// Use the $lookup aggregation pipeline operator in order to get the description of each major. Name the resulting field 'major_detail'.

db.students.aggregate(
    [
        {
            $unwind: "$majors"
        }, 
        {
            $lookup: {
                from: "majors",
                localField: "majors",
                foreignField: "_id", 
                as: "major_detail"
            }
        }
    ]
)

// Stage 3: “unwind” major_detail
// In theory the $lookup operator can potentially find more than one document in the foreign table (majors in the example) that matches the local field. Therefore, major_detail is an array of documents found in majors that matched the search local field. You need to "unwind" that array in order to produce documents with single-value major details.

db.students.aggregate(
    [
        {
            $unwind: "$majors"
        }, 
        {
            $lookup: {
                from: "majors",
                localField: "majors",
                foreignField: "_id", 
                as: "major_detail"
            }
        }, 
        {
            $unwind: "$major_detail"
        }
    ]
)

// Stage 4: group and push
// On this stage you will group documents by _id and name and create an array called majors where you are going to push the name and the description of the student's major.

db.students.aggregate(
    [
        {
            $unwind: "$majors"
        }, 
        {
            $lookup: {
                from: "majors",
                localField: "majors",
                foreignField: "_id", 
                as: "major_detail"
            }
        }, 
        {
            $unwind: "$major_detail"
        }, 
        {
            $group: {
                _id: {
                    _id: "$_id", 
                    name: "$name"
                }, 
                majors: {
                    $push: {
                        name: "$major_detail._id", 
                        description: "$major_detail.description"
                    }
                }
            }
        }, 
        {
            $project: {
                _id: "$_id._id", 
                name: "$_id.name", 
                majors: "$majors"
            }
        }
    ]
)